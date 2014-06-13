\set ON_ERROR_ROLLBACK 1
\set ON_ERROR_STOP true

SELECT set_config('search_path','mimeo, dblink, public',false);

SELECT plan(63);

SELECT dblink_connect('mimeo_test', 'host=localhost port=5432 dbname=mimeo_source user=mimeo_owner password=mimeo_owner');
SELECT is(dblink_get_connections() @> '{mimeo_test}', 't', 'Remote database connection established');

-- ########## SNAPSHOT DESTROYER ##########
SELECT snapshot_destroyer('mimeo_dest.snap_test_dest');
SELECT has_table('mimeo_dest', 'snap_test_dest', 'Check snapshot_destroyer changed view into table: mimeo_dest.snap_test_dest');
SELECT hasnt_view('mimeo_dest', 'snap_test_dest', 'Check snapshot_destroyer dropped view: mimeo_dest.snap_test_dest');
SELECT hasnt_table('mimeo_dest', 'snap_test_dest_snap1', 'Check snapshot_destroyer dropped table: mimeo_dest.snap_test_dest_snap1');
SELECT hasnt_table('mimeo_dest', 'snap_test_dest_snap2', 'Check snapshot_destroyer dropped table: mimeo_dest.snap_test_dest_snap2');
DROP TABLE mimeo_dest.snap_test_dest;
SELECT hasnt_table('mimeo_dest', 'snap_test_dest', 'Check table dropped: mimeo_dest.snap_test_dest');

SELECT snapshot_destroyer('mimeo_source.snap_test_source', false);
SELECT hasnt_view('mimeo_source', 'snap_test_source', 'Check snapshot_destroyer dropped view: mimeo_source.snap_test_source');
SELECT hasnt_table('mimeo_source', 'snap_test_source_snap1', 'Check snapshot_destroyer dropped table: mimeo_source.snap_test_source_snap1');
SELECT hasnt_table('mimeo_source', 'snap_test_source_snap2', 'Check snapshot_destroyer dropped table: mimeo_source.snap_test_source_snap2');

SELECT snapshot_destroyer('mimeo_dest.snap_test_dest_nodata', false);
SELECT hasnt_view('mimeo_dest', 'snap_test_dest_nodata', 'Check snapshot_destroyer dropped view: mimeo_dest.snap_test_dest_nodata');
SELECT hasnt_table('mimeo_dest', 'snap_test_dest_nodata_snap1', 'Check snapshot_destroyer dropped table: mimeo_dest.snap_test_dest_nodata_snap1');
SELECT hasnt_table('mimeo_dest', 'snap_test_dest_nodata_snap2', 'Check snapshot_destroyer dropped table: mimeo_dest.snap_test_dest_nodata_snap2');

SELECT snapshot_destroyer('mimeo_dest.snap_test_dest_filter', false);
SELECT hasnt_view('mimeo_dest', 'snap_test_dest_filter', 'Check snapshot_destroyer dropped view: mimeo_dest.snap_test_dest_filter');
SELECT hasnt_table('mimeo_dest', 'snap_test_dest_filter_snap1', 'Check snapshot_destroyer dropped table: mimeo_dest.snap_test_dest_filter_snap1');
SELECT hasnt_table('mimeo_dest', 'snap_test_dest_filter_snap2', 'Check snapshot_destroyer dropped table: mimeo_dest.snap_test_dest_filter_snap2');

SELECT snapshot_destroyer('mimeo_dest.snap_test_dest_condition', false);
SELECT hasnt_view('mimeo_dest', 'snap_test_dest_condition', 'Check snapshot_destroyer dropped view: mimeo_dest.snap_test_dest_condition');
SELECT hasnt_table('mimeo_dest', 'snap_test_dest_condition_snap1', 'Check snapshot_destroyer dropped table: mimeo_dest.snap_test_dest_condition_snap1');
SELECT hasnt_table('mimeo_dest', 'snap_test_dest_condition_snap2', 'Check snapshot_destroyer dropped table: mimeo_dest.snap_test_dest_condition_snap2');

SELECT snapshot_destroyer('mimeo_source.snap_test_source_empty', false);
SELECT hasnt_view('mimeo_source', 'snap_test_source_empty', 'Check snapshot_destroyer dropped view: mimeo_source.snap_test_source_empty');
SELECT hasnt_table('mimeo_source', 'snap_test_source_empty_snap1', 'Check snapshot_destroyer dropped table: mimeo_source.snap_test_source_empty_snap1');
SELECT hasnt_table('mimeo_source', 'snap_test_source_empty_snap2', 'Check snapshot_destroyer dropped table: mimeo_source.snap_test_source_empty_snap2');

SELECT snapshot_destroyer('mimeo_dest.snap_test_dest_change_col', false);
SELECT hasnt_view('mimeo_dest', 'snap_test_dest_change_col', 'Check snapshot_destroyer dropped view: mimeo_dest.snap_test_dest_change_col');
SELECT hasnt_table('mimeo_dest', 'snap_test_dest_change_col_snap1', 'Check snapshot_destroyer dropped table: mimeo_dest.snap_test_dest_change_col_snap1');
SELECT hasnt_table('mimeo_dest', 'snap_test_dest_change_col_snap2', 'Check snapshot_destroyer dropped table: mimeo_dest.snap_test_dest_change_col_snap2');

-- ########## PLAIN TABLE DESTROYER ##########
SELECT table_destroyer('mimeo_dest.table_test_dest');
SELECT has_table('mimeo_dest', 'table_test_dest', 'Check table_destroyer kept destination table: mimeo_dest.table_test_dest');
DROP TABLE mimeo_dest.table_test_dest;
SELECT hasnt_table('mimeo_dest', 'table_test_dest', 'Check table dropped: mimeo_dest.table_test_dest');

SELECT table_destroyer('mimeo_dest.table_test_dest_nodata', false);
SELECT hasnt_table('mimeo_dest', 'table_test_dest_nodata', 'Check table_destroyer dropped table: mimeo_dest.table_test_dest_nodata');
SELECT table_destroyer('mimeo_dest.table_test_dest_filter', false);
SELECT hasnt_table('mimeo_dest', 'table_test_dest_filter', 'Check table_destroyer dropped table: mimeo_dest.table_test_dest_filter');
SELECT table_destroyer('mimeo_dest.table_test_dest_condition', false);
SELECT hasnt_table('mimeo_dest', 'table_test_dest_condition', 'Check table_destroyer dropped table: mimeo_dest.table_test_dest_condition');
SELECT table_destroyer('mimeo_dest.table_test_dest_empty', false);
SELECT hasnt_table('mimeo_dest', 'table_test_dest_empty', 'Check table_destroyer dropped table: mimeo_dest.table_test_source_empty');


-- ########## INSERTER DESTROYER ##########
SELECT inserter_destroyer('mimeo_dest.inserter_test_dest');
SELECT has_table('mimeo_dest', 'inserter_test_dest', 'Check inserter_destroyer kept destination table: mimeo_dest.inserter_test_dest');
DROP TABLE mimeo_dest.inserter_test_dest;
SELECT hasnt_table('mimeo_dest', 'inserter_test_dest', 'Check table dropped: mimeo_dest.inserter_test_dest');

SELECT inserter_destroyer('mimeo_source.inserter_test_source', false);
SELECT hasnt_table('mimeo_source', 'inserter_test_source', 'Check inserter_destroyer dropped table: mimeo_source.inserter_test_source');
SELECT inserter_destroyer('mimeo_dest.inserter_test_dest_nodata', false);
SELECT hasnt_table('mimeo_dest', 'inserter_test_dest_nodata', 'Check inserter_destroyer dropped table: mimeo_dest.inserter_test_dest_nodata');
SELECT inserter_destroyer('mimeo_dest.inserter_test_dest_filter', false);
SELECT hasnt_table('mimeo_dest', 'inserter_test_dest_filter', 'Check inserter_destroyer dropped table: mimeo_dest.inserter_test_dest_filter');
SELECT inserter_destroyer('mimeo_dest.inserter_test_dest_condition', false);
SELECT hasnt_table('mimeo_dest', 'inserter_test_dest_condition', 'Check inserter_destroyer dropped table: mimeo_dest.inserter_test_dest_condition');
SELECT inserter_destroyer('mimeo_source.inserter_test_source_empty', false);
SELECT hasnt_table('mimeo_source', 'inserter_test_source_empty', 'Check inserter_destroyer dropped table: mimeo_source.inserter_test_source_empty');

SELECT inserter_destroyer('mimeo_dest.inserter_test_dest_serial', false);
SELECT hasnt_table('mimeo_dest', 'inserter_test_dest_serial', 'Check inserter_destroyer dropped table: mimeo_source.inserter_test_dest_serial');

-- ########## UPDATER DESTROYER ##########
SELECT updater_destroyer('mimeo_dest.updater_test_dest');
SELECT has_table('mimeo_dest', 'updater_test_dest', 'Check updater_destroyer kept destination table: mimeo_dest.updater_test_dest');
DROP TABLE mimeo_dest.updater_test_dest;
SELECT hasnt_table('mimeo_dest', 'updater_test_dest', 'Check table dropped: mimeo_dest.updater_test_dest');

SELECT updater_destroyer('mimeo_source.updater_test_source', false);
SELECT hasnt_table('mimeo_source', 'updater_test_source', 'Check updater_destroyer dropped table: mimeo_source.updater_test_source');
SELECT updater_destroyer('mimeo_dest.updater_test_dest_nodata', false);
SELECT hasnt_table('mimeo_dest', 'updater_test_dest_nodata', 'Check updater_destroyer dropped table: mimeo_dest.updater_test_dest_nodata');
SELECT updater_destroyer('mimeo_dest.updater_test_dest_filter', false);
SELECT hasnt_table('mimeo_dest', 'updater_test_dest_filter', 'Check updater_destroyer dropped table: mimeo_dest.updater_test_dest_filter');
SELECT updater_destroyer('mimeo_dest.updater_test_dest_condition', false);
SELECT hasnt_table('mimeo_dest', 'updater_test_dest_condition', 'Check updater_destroyer dropped table: mimeo_dest.updater_test_dest_condition');
SELECT updater_destroyer('mimeo_source.updater_test_source_empty', false);
SELECT hasnt_table('mimeo_source', 'updater_test_source_empty', 'Check updater_destroyer dropped table: mimeo_source.updater_test_source_empty');

SELECT updater_destroyer('mimeo_dest.updater_test_dest_serial', false);
SELECT hasnt_table('mimeo_dest', 'updater_test_dest_serial', 'Check updater_destroyer dropped table: mimeo_dest.updater_test_dest_serial');

-- ########## DML DESTROYER ##########
-- Have to change the owner of the source tables in order to be able to drop triggers
SELECT dblink_exec('mimeo_test', 'ALTER TABLE mimeo_source.dml_test_source OWNER TO mimeo_test');
SELECT dblink_exec('mimeo_test', 'ALTER TABLE mimeo_source.dml_test_source2 OWNER TO mimeo_test');
SELECT dblink_exec('mimeo_test', 'ALTER TABLE mimeo_source.dml_test_source_nodata OWNER TO mimeo_test');
SELECT dblink_exec('mimeo_test', 'ALTER TABLE mimeo_source.dml_test_source_filter OWNER TO mimeo_test');
SELECT dblink_exec('mimeo_test', 'ALTER TABLE mimeo_source.dml_test_source_condition OWNER TO mimeo_test');
SELECT dblink_exec('mimeo_test', 'ALTER TABLE mimeo_source.dml_test_source_empty OWNER TO mimeo_test');

SELECT dml_destroyer('mimeo_dest.dml_test_dest');
SELECT has_table('mimeo_dest', 'dml_test_dest', 'Check dml_destroyer kept destination table: mimeo_dest.dml_test_dest');
DROP TABLE mimeo_dest.dml_test_dest;
SELECT hasnt_table('mimeo_dest', 'dml_test_dest', 'Check table dropped: mimeo_dest.dml_test_dest');

SELECT dml_destroyer('mimeo_dest.dml_test_dest_multi', false);
SELECT hasnt_table('mimeo_dest', 'dml_test_dest_multi', 'Check dml_destroyer dropped table: mimeo_dest.dml_test_dest_multi');
SELECT dml_destroyer('mimeo_source.dml_test_source', false);
SELECT hasnt_table('mimeo_source', 'dml_test_source', 'Check dml_destroyer dropped table: mimeo_source.dml_test_source');
SELECT dml_destroyer('mimeo_dest.dml_test_dest_nodata', false);
SELECT hasnt_table('mimeo_dest', 'dml_test_dest_nodata', 'Check dml_destroyer dropped table: mimeo_dest.dml_test_dest_nodata');
SELECT dml_destroyer('mimeo_dest.dml_test_dest_filter', false);
SELECT hasnt_table('mimeo_dest', 'dml_test_dest_filter', 'Check dml_destroyer dropped table: mimeo_dest.dml_test_dest_filter');
SELECT dml_destroyer('mimeo_dest.dml_test_dest_condition', false);
SELECT hasnt_table('mimeo_dest', 'dml_test_dest_condition', 'Check dml_destroyer dropped table: mimeo_dest.dml_test_dest_condition');
SELECT dml_destroyer('mimeo_source.dml_test_source_empty', false);
SELECT hasnt_table('mimeo_source', 'dml_test_source_empty', 'Check dml_destroyer dropped table: mimeo_source.dml_test_source_empty');


-- ########## LOGDEL DESTROYER ##########
-- Have to change the owner of the source tables in order to be able to drop triggers
SELECT dblink_exec('mimeo_test', 'ALTER TABLE mimeo_source.logdel_test_source OWNER TO mimeo_test');
SELECT dblink_exec('mimeo_test', 'ALTER TABLE mimeo_source.logdel_test_source2 OWNER TO mimeo_test');
SELECT dblink_exec('mimeo_test', 'ALTER TABLE mimeo_source.logdel_test_source_nodata OWNER TO mimeo_test');
SELECT dblink_exec('mimeo_test', 'ALTER TABLE mimeo_source.logdel_test_source_filter OWNER TO mimeo_test');
SELECT dblink_exec('mimeo_test', 'ALTER TABLE mimeo_source.logdel_test_source_condition OWNER TO mimeo_test');
SELECT dblink_exec('mimeo_test', 'ALTER TABLE mimeo_source.logdel_test_source_empty OWNER TO mimeo_test');

SELECT logdel_destroyer('mimeo_dest.logdel_test_dest');
SELECT has_table('mimeo_dest', 'logdel_test_dest', 'Check logdel_destroyer kept destination table: mimeo_dest.logdel_test_dest');
DROP TABLE mimeo_dest.logdel_test_dest;
SELECT hasnt_table('mimeo_dest', 'logdel_test_dest', 'Check table dropped: mimeo_dest.logdel_test_dest');

SELECT logdel_destroyer('mimeo_dest.logdel_test_dest_multi', false);
SELECT hasnt_table('mimeo_dest', 'logdel_test_dest_multi', 'Check logdel_destroyer dropped table: mimeo_dest.logdel_test_dest_multi');
SELECT logdel_destroyer('mimeo_source.logdel_test_source', false);
SELECT hasnt_table('mimeo_source', 'logdel_test_source', 'Check logdel_destroyer dropped table: mimeo_source.logdel_test_source');
SELECT logdel_destroyer('mimeo_dest.logdel_test_dest_nodata', false);
SELECT hasnt_table('mimeo_dest', 'logdel_test_dest_nodata', 'Check logdel_destroyer dropped table: mimeo_dest.logdel_test_dest_nodata');
SELECT logdel_destroyer('mimeo_dest.logdel_test_dest_filter', false);
SELECT hasnt_table('mimeo_dest', 'logdel_test_dest_filter', 'Check logdel_destroyer dropped table: mimeo_dest.logdel_test_dest_filter');
SELECT logdel_destroyer('mimeo_dest.logdel_test_dest_condition', false);
SELECT hasnt_table('mimeo_dest', 'logdel_test_dest_condition', 'Check logdel_destroyer dropped table: mimeo_dest.logdel_test_dest_condition');
SELECT logdel_destroyer('mimeo_source.logdel_test_source_empty', false);
SELECT hasnt_table('mimeo_source', 'logdel_test_source_empty', 'Check logdel_destroyer dropped table: mimeo_source.logdel_test_source_empty');


SELECT is_empty('SELECT dest_table FROM mimeo.refresh_config WHERE dest_table IN (
    ''mimeo_source.snap_test_source''
    , ''mimeo_dest.snap_test_dest''
    , ''mimeo_dest.snap_test_dest_nodata''
    , ''mimeo_dest.snap_test_dest_filter''
    , ''mimeo_dest.snap_test_dest_condition''
    , ''mimeo_source.snap_test_source_empty''
    , ''mimeo_source.inserter_test_source''
    , ''mimeo_dest.inserter_test_dest''
    ,  ''mimeo_dest.inserter_test_dest_nodata''
    , ''mimeo_dest.inserter_test_dest_filter''
    , ''mimeo_dest.inserter_test_dest_condition''
    , ''mimeo_source.inserter_test_source_empty''
    ,  ''mimeo_source.updater_test_source''
    , ''mimeo_dest.updater_test_dest''
    , ''mimeo_dest.updater_test_dest_nodata''
    ,  ''mimeo_dest.updater_test_dest_filter''
    , ''mimeo_dest.updater_test_dest_condition''
    ,  ''mimeo_source.updater_test_source_empty''
    , ''mimeo_source.dml_test_source''
    , ''mimeo_dest.dml_test_dest''
    ,  ''mimeo_dest.dml_test_dest_nodata''
    , ''mimeo_dest.dml_test_dest_filter''
    , ''mimeo_dest.dml_test_dest_condition''
    , ''mimeo_source.dml_test_source_empty''
    , ''mimeo_source.logdel_test_source''
    ,  ''mimeo_dest.logdel_test_dest''
    , ''mimeo_dest.logdel_test_dest_nodata''
    , ''mimeo_dest.logdel_test_dest_filter''
    ,  ''mimeo_dest.logdel_test_dest_condition''
    , ''mimeo_source.logdel_test_source_empty''
    )', 'Checking that test config data has been cleared from refresh.config');


SELECT * FROM finish();


