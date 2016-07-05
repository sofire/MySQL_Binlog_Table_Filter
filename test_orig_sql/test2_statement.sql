/*!50530 SET @@SESSION.PSEUDO_SLAVE_MODE=1*/;
/*!40019 SET @@session.max_insert_delayed_threads=0*/;
/*!50003 SET @OLD_COMPLETION_TYPE=@@COMPLETION_TYPE,COMPLETION_TYPE=0*/;
DELIMITER /*!*/;
# at 4
#160705 14:50:57 server id 1  end_log_pos 120 CRC32 0x9a10b9b3 	Start: binlog v 4, server v 5.6.26-log created 160705 14:50:57 at startup
# Warning: this binlog is either in use or was not closed properly.
ROLLBACK/*!*/;
BINLOG '
0Vh7Vw8BAAAAdAAAAHgAAAABAAQANS42LjI2LWxvZwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAADRWHtXEzgNAAgAEgAEBAQEEgAAXAAEGggAAAAICAgCAAAACgoKGRkAAbO5
EJo=
'/*!*/;
# at 120
#160705 14:51:05 server id 1  end_log_pos 219 CRC32 0x45a70b4d 	Query	thread_id=1	exec_time=0	error_code=0
SET TIMESTAMP=1467701465/*!*/;
SET @@session.pseudo_thread_id=1/*!*/;
SET @@session.foreign_key_checks=1, @@session.sql_auto_is_null=0, @@session.unique_checks=1, @@session.autocommit=1/*!*/;
SET @@session.sql_mode=1073741824/*!*/;
SET @@session.auto_increment_increment=1, @@session.auto_increment_offset=1/*!*/;
/*!\C utf8 *//*!*/;
SET @@session.character_set_client=33,@@session.collation_connection=33,@@session.collation_server=8/*!*/;
SET @@session.lc_time_names=0/*!*/;
SET @@session.collation_database=DEFAULT/*!*/;
create database `test2`
/*!*/;
# at 219
#160705 14:51:24 server id 1  end_log_pos 340 CRC32 0x15b2d1c9 	Query	thread_id=1	exec_time=0	error_code=0
use `test2`/*!*/;
SET TIMESTAMP=1467701484/*!*/;
Create table `test2`.`tbl1`(  
  `id` int
)
/*!*/;
# at 340
#160705 14:51:36 server id 1  end_log_pos 557 CRC32 0x6547fac7 	Query	thread_id=1	exec_time=0	error_code=0
SET TIMESTAMP=1467701496/*!*/;
Alter table `test2`.`tbl1`   
  change `id` `id` int(11) NOT NULL,
  add column `name` char(10) NULL after `id`, 
  add primary key (`id`)
/*!*/;
# at 557
#160705 14:51:52 server id 1  end_log_pos 638 CRC32 0x36e30b01 	Query	thread_id=1	exec_time=0	error_code=0
SET TIMESTAMP=1467701512/*!*/;
BEGIN
/*!*/;
# at 638
#160705 14:51:52 server id 1  end_log_pos 762 CRC32 0x0db07a4a 	Query	thread_id=1	exec_time=0	error_code=0
SET TIMESTAMP=1467701512/*!*/;
insert into `test2`.`tbl1` (`name`) values ('a')
/*!*/;
# at 762
#160705 14:51:52 server id 1  end_log_pos 793 CRC32 0xe08d8fab 	Xid = 36
COMMIT/*!*/;
# at 793
# at 825
#160705 14:52:08 server id 1  end_log_pos 825 CRC32 0xdc2c530e 	Intvar
SET INSERT_ID=1/*!*/;
#160705 14:52:08 server id 1  end_log_pos 991 CRC32 0x17e2123d 	Query	thread_id=1	exec_time=0	error_code=0
SET TIMESTAMP=1467701528/*!*/;
Alter table `test2`.`tbl1`   
  change `id` `id` int(11) UNSIGNED NOT NULL Auto_increment
/*!*/;
# at 991
#160705 14:52:12 server id 1  end_log_pos 1072 CRC32 0x3577886c 	Query	thread_id=1	exec_time=0	error_code=0
SET TIMESTAMP=1467701532/*!*/;
BEGIN
/*!*/;
# at 1072
# at 1104
#160705 14:52:12 server id 1  end_log_pos 1104 CRC32 0x05f558d5 	Intvar
SET INSERT_ID=2/*!*/;
#160705 14:52:12 server id 1  end_log_pos 1228 CRC32 0x23b9db9d 	Query	thread_id=1	exec_time=0	error_code=0
SET TIMESTAMP=1467701532/*!*/;
insert into `test2`.`tbl1` (`name`) values ('b')
/*!*/;
# at 1228
#160705 14:52:12 server id 1  end_log_pos 1259 CRC32 0xd248ee38 	Xid = 48
COMMIT/*!*/;
DELIMITER ;
# End of log file
ROLLBACK /* added by mysqlbinlog */;
/*!50003 SET COMPLETION_TYPE=@OLD_COMPLETION_TYPE*/;
/*!50530 SET @@SESSION.PSEUDO_SLAVE_MODE=0*/;
