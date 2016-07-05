#!/usr/bin/perl

# 过滤Mysqlbinlog中指定库的特定表
# 只测试了row格式的binlog
#
# 第一步(导出指定库的所有日志）：
# mysqlbinlog -d db1 -v binlog.000001 > db1.sql
# mysqlbinlog -d db1 -v --start-datetime='xxxxx' --stop-datetime='xxxxx' binlog.000001 > db1.sql
# mysqlbinlog -d db1 -v --start-position='xxxxx' --stop-position='xxxxx' binlog.000001 > db1.sql
#
# 第二步：用本脚本过滤
# perl myfilter.pl --tables tbl1,tbl2 --src db1.sql

# 基于https://github.com/sillydong/MySQL_Binlog_Table_Filter
# MySQL_Binlog_Table_Filter
# By Chen.Zhidong
# njutczd+gmail.com

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
use strict;
use Getopt::Long;

my $version = "1.0";

my %opt = (
		"tables"=>"",
		"enable-drop"=>0,
		"enable-truncate"=>0,
		"src"=>"",
	);

GetOptions(\%opt,
		"tables=s",
		"enable-drop",
		"enable-truncate",
		"src=s",
		"help"
	) || die usage();

sub usage {
	print "\n".
	"    MySQL Exported Binlog Filter $version\n".
	"    Options:\n".
	"        --tables <tablenames>       export tables in tablenames, deliminate by ","\n".
	"        --enable-drop               enable DROP, optional, default disabled\n".
	"        --enable-truncate           enable TRUNCATE, optional, default disabled\n".
	"        --src <exported sql file>   read from sql file\n".
	"        --help                      print help message\n".
	"\n".
	"    Example:\n".
	"        $0 --tables hello,hi --enable-drop --enable-truncate --src src.sql\n".
	"\n";
	exit;
}

if(defined $opt{'help'} && $opt{'help'}) { usage(); }

if($opt{'tables'} eq "" || $opt{'src'} eq "")
{
	usage();
}

open(FILE,"<",$opt{'src'}) || die "can not open file $opt{'src'}\n";

my @tables=split(/,/,$opt{'tables'});

my $block="";
my $line="";
my $end_log_pos=0;
my $matchfilter=0;
my $delimiter="";


my $lineNum = 0;

while($line=<FILE>)
{
    $lineNum++;

	if($line ne "")
	{
        if ($lineNum == 1 && $line !~ /PSEUDO_SLAVE_MODE/){
            print "Only support Row format binlog.";
            exit;
        }

        if ($lineNum <= 13){
            print $line;
            next;
        }
        elsif ($lineNum == 14){
            print "\n\n";
        }

		if($line =~ /^\/\*/ && $matchfilter)
		{
            $block.=$line;
			#do nothing
		}
		elsif($line =~ /^DELIMITER\s+(.+)/i)
		{
            $delimiter=$1;
            #$block.=$line;
            #print $line;
		}
        elsif($line =~ /^#\d+.+end_log_pos (\d+).+Table_map: `[\w_]+`\.`?([\w_]+)`?.+/i)
        {
            #table_map
			$end_log_pos=$1;
            if ($2 ~~ @tables)
            {
                $block.=$line;
                $matchfilter=1;
            }
        }
		elsif($line =~ /^#\d+.+end_log_pos (\d+) .*/)
		{
			#determin end_log_pos
			$end_log_pos=$1;
			$block.=$line;
		}
		elsif($line =~ /# at (\d+)/)
		{
			if($end_log_pos == $1 && $matchfilter)
			{
				#meet end_log_pos and print if table matches
                #$block.=$line;
				print $block;
			}
			#clean variables
            #$block="";
            $block="\n\n" . $line;
			$end_log_pos=0;
			$matchfilter=0;
		}
		else
		{
            if($line =~ /^[ #]*update `[\w_]+`\.`?([\w_]+)`?.*/i)
			{
				#update
				if ($1 ~~ @tables)
				{
					$block.=$line;
					$matchfilter=1;
				}
			}
			elsif($line =~ /^[ #]*insert into `[\w_]+`\.`?([\w_]+)`?.*/i)
			{
				#insert
				if ($1 ~~ @tables)
				{
					$block.=$line;
					$matchfilter=1;
				}
			}
			elsif($line =~ /^[ #]*delete from `[\w_]+`\.`?([\w_]+)`?.*/i)
			{
				#delete
				if ($1 ~~ @tables)
				{
					$block.=$line;
					$matchfilter=1;
				}
			}
			elsif($line =~ /^ *create table (`[\w_]+`\.)?`?([\w_]+)`?.*/i)
			{
				#create table
				if ($2 ~~ @tables)
				{
					$block.=$line;
					$matchfilter=1;
				}
			}
			elsif($line =~ /^ *alter table (`[\w_]+`\.)?`?([\w_]+)`?.*/i)
			{
				#alter
				if ($2 ~~ @tables)
				{
					$block.=$line;
					$matchfilter=1;
				}
			}
			elsif($opt{'enable-drop'} && $line =~ /^ *drop table `?([\w_]+)`?.+/i)
			{
				#drop
				if ($1 ~~ @tables)
				{
					$block.=$line;
					$matchfilter=1;
				}
			}
			elsif($opt{'enable-truncate'} && $line =~ /^ *truncate table `?([a-z_]+)`?.*/i)
			{
				#truncate
				if ($1 ~~ @tables)
				{
					$block.=$line;
					$matchfilter=1;
				}
			}
			elsif($line =~ /^ *create .*index .+ on `?([a-z_]+)`? .+/i)
			{
				#create index
				if ($1 ~~ @tables)
				{
					$block.=$line;
					$matchfilter=1;
				}
			}
			elsif($line =~/^ *create view .+ from `?([a-z_]+)`? .+/i)
			{
				#create view
				if ($1 ~~ @tables)
				{
					$block.=$line;
					$matchfilter=1;
				}
			}
			else
			{
				$block.=$line;
			}
		}
	}
}

close FILE;
