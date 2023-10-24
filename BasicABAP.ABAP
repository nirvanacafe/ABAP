*链接语句
data(l_num) = 1.
l_num = l_num + 1.
l_num = l_num + 2.
l_num = l_num + 3.
write l_num.
l_num = l_num + : 1,2,3.
write l_num.
*数据类型
data l_i type i .
data l_f type f.
data l_p type p.
data l_c type c.
data l_d type d.
data l_n type n.
data l_t type t.
data l_x type x.
data l_string type string.
data l_xtring type xstring.

write:l_i,
/ l_f,
/ l_p,
/ l_c,
/ l_d,
/ l_n,
/ l_t,
/ l_x,
/ l_string,
/ l_xtring.

X 1字节 任何字节值(00到FF)
C 1个字符 1〜65535
N 1个字符 1〜65535
D 8个字符 8个字符
T 6个字符 6个字符
I 4字节 -2147483648至2147483647
F 8字节 2.2250738585072014E-308至1.7976931348623157E + 308正或负
P 8字节 [-10 ^(2len -1)+1]到[+ 10 ^(2len -1)1](其中len =固定长度)
STRING Variable 任何字母数字字符
XSTRING Variable 任何字节值(00到FF)
*静态变量
CLASS cls DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS meth.
ENDCLASS.

CLASS cls IMPLEMENTATION.
  METHOD meth.
    DATA    local  TYPE i VALUE 10.
    STATICS static TYPE i VALUE 10.
    local  = local  + 1.
    static = static + 1.
    cl_demo_output=>write( |Local: { local }, | &&
                           |Static: { static }| ).
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  DO 10 TIMES.
    cls=>meth( ).
  ENDDO.
  cl_demo_output=>display( ).
  
*OBJECTS_REFERENCES  

REPORT demo_objects_references.

CLASS counter DEFINITION.
  PUBLIC SECTION.
    METHODS: set IMPORTING VALUE(set_value) TYPE i,
             increment,
             get EXPORTING VALUE(get_value) TYPE i.
  PRIVATE SECTION.
    DATA count TYPE i.
ENDCLASS.

CLASS counter IMPLEMENTATION.
  METHOD set.
    count = set_value.
  ENDMETHOD.
  METHOD increment.
    ADD 1 TO count.
  ENDMETHOD.
  METHOD get.
    get_value = count.
  ENDMETHOD.
ENDCLASS.

DATA: cnt_1 TYPE REF TO counter,
      cnt_2 TYPE REF TO counter,
      cnt_3 TYPE REF TO counter,
      cnt_tab TYPE TABLE OF REF TO counter.

DATA number TYPE i.

START-OF-SELECTION.

  CREATE OBJECT: cnt_1,
                 cnt_2.

  MOVE cnt_2 TO cnt_3.

  CLEAR cnt_2.

  cnt_3 = cnt_1.

  CLEAR cnt_3.

  APPEND cnt_1 TO cnt_tab.

  CREATE OBJECT: cnt_2,
                 cnt_3.

  APPEND: cnt_2 TO cnt_tab,
          cnt_3 TO cnt_tab.

  CALL METHOD cnt_1->set EXPORTING set_value = 1.

  CALL METHOD cnt_2->set EXPORTING set_value = 10.

  CALL METHOD cnt_3->set EXPORTING set_value = 100.

  DO 3 TIMES.
    CALL METHOD: cnt_1->increment,
                 cnt_2->increment,
                 cnt_3->increment.
  ENDDO.

  LOOP AT cnt_tab INTO cnt_1.
    CALL METHOD cnt_1->get IMPORTING get_value = number.
    cl_demo_output=>write_text( |{ number }| ).
  ENDLOOP.

  cl_demo_output=>display( ).
*&---------------------------------------------------------------------*
*& Report YTEST_ZJ009
*&---------------------------------------------------------------------*
*&new为最新理解
*&---------------------------------------------------------------------*
REPORT YTEST_ZJ009.
*TABLES
TABLES:ytest_ng.
TYPES: BEGIN OF ty_data.
CLASS cls DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS meth.
ENDCLASS.

CLASS cls IMPLEMENTATION.
  METHOD meth.
    DATA    local  TYPE i VALUE 10.
    STATICS static TYPE i VALUE 10.
    local  = local  + 1.
    static = static + 1.
    cl_demo_output=>write( |Local: { local }, | &&
                           |Static: { static }| ).
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  DO 10 TIMES.
    cls=>meth( ).
  ENDDO.
  cl_demo_output=>display( ).
    INCLUDE TYPE ytest_ng.
TYPES: flag TYPE char1,
       END OF ty_data.
CONSTANTS:c_name2(4)      VALUE '王明',
          c_gender2(1)    VALUE '男',
          c_education2(2) VALUE '专科',
          c_rank1(4)      VALUE '销售主管',
          c_rank2(4)      VALUE '销售雇员',
          c_name3(4)      VALUE 'LISA',
          c_gender3(1)    VALUE '女',
          c_education3(2) VALUE '本科',
          c_name4(4)      VALUE 'TOM'.

*连接字符串
*5> 定义变量输出去年的明天，并输出（使用新语法连接字符串）
DATA(lv_date) = |{ sy-datum(4) - 1 }{ sy-datum+4 + 1 } |.
*DATA(lv_date1) = ( sy-datum(4) - 1 ) && ( sy-datum+4 + 1 ).
cl_demo_output=>write( lv_date ).

*&----------------------------------------------------------------------
* 练习二：构造表达式
* 1. 值构造:  VALUE - 创建一个类型为dypee的数据
*     2.1 构造结构
*         语法： ... VALUE dtype | #(  [BASE dobj] comp1 = dobj1 comp2 = dobj2 ... ) ...
*     2.2 构造内表 ：
*         语法： ... VALUE dtype | #( [BASE itab] (  (line1-com1 = dobj1) ( line2 ..) ... ) ...
*     note: dytpe可接具体类型或者# ，接#数据类型必须确定
*           可以嵌套使用；
*           内表赋值不能带表头；
*&---------------------------------------------------------------------*
cl_demo_output=>write( '练习二：构造表达式' ).
*1> 结构赋值 (id :2  name :王明 gender:男 education：专科 rank：销售雇员)/输出
gs_data = VALUE #( id = 2 name = c_name2 gender = c_gender2
            education = c_education2 rank = c_rank2 ).
DATA(gw_data) = VALUE ty_data( id = 2 name = c_name2 gender = c_gender2
            education = c_education2 rank = c_rank2 ).
cl_demo_output=>write( gs_data ).
*2> 结构内附加王明薪资信息为6000/输出
gs_data = VALUE #( BASE gs_data salary = 6000 ).
cl_demo_output=>write( gs_data ).

*3> 结构内修改王明薪资为5000，更新至内表/输出内表
gs_data = VALUE #( BASE gs_data salary = 5000 ).
APPEND gs_data TO gt_data.
cl_demo_output=>write( gt_data ).

*4> 内表基础上附加额外数据之后，更新TABLE:YTEST_NG
*id :3  name :LISA gender:女 education：本科 rank：销售雇员
*id :4  name :TOM  gender:男 education：专科 rank：销售雇员
gt_data = VALUE #( BASE gt_data ( id = 3 name = c_name3 gender =
    c_gender3 education = c_education3 rank = c_rank2 salary = 4300 )
                                ( id = 4 name = c_name4 gender =
    c_gender2 education = c_education2 rank = c_rank2 salary = 4400  ) ).
cl_demo_output=>write( gt_data ).
*4.1new>内表基础上附加额外数据
APPEND VALUE #( id = 9 ) TO gt_data.
MODIFY ytest_ng FROM TABLE gt_data.

*5> 定义Range 表并赋值 id = 1 和 id>=3
DATA:   r_range    TYPE RANGE OF ytest_ng-id.
r_range  = VALUE #( sign = 'I'   ( option = 'EQ' low = 1 )
                                 ( option = 'GE' low  = 3 )
                    sign = 'E' ( option = 'EQ' low = 2 )
                ).
cl_demo_output=>write( r_range ).
*&----------------------------------------------------------------------
* 练习三：内表操作
* 1. 内表表达式- 相当于READ TABLE
*    语法：… itab[ … ] …
*     note: 如果未找到对应的记录就会抛出CX_SY_ITAB_LINE_NOT_FOUND异常，SY-SUBRC不会记录
*           可以通过line_exists预定义函数改进
* 2. 內表预定义函数
*     2.1 line_exists( ) - 判断记录是否存在
*     2.2 line_index( )  - 获取符合记录的索引值
* 3. 內表筛选-FILTER -筛选内表中的数据
*     语法：  FILTER  type(  itab   [EXCEPT]   [IN ftab]   [USING KEY keyname ]
*                            WHERE c1 op f1  [AND c2 op f2  [...] ]  ) ...
*      note: WHERE对应过滤的条件，是必须要指定的，注意有些操作符是不能在WHERE中使用的，如：OR , NOT 等
*            EXCEPT如果不指定则表示满足条件的找出来，如果指定则表示不满足条件的找出来
* 4. 內表缩减
*      语法： ... REDUCE type(
*                              [let_exp]
*                              INIT {x1 = rhs1}|{<x1> = wrexpr1}|{x1|<x1> TYPE dtype1}
*                                   {x2 = rhs2}|{<x2> = wrexpr2}|{x2|<x2> TYPE dtype2}
*                                   ...
*                              FOR for_exp1
*                              FOR for_exp2
*                              ...
*                              NEXT ...
*                                   {x1 = rhs1}|{<x1> = wrexpr1}
*                                   {x2 = rhs2}|{<x2> = wrexpr2}
*                                   ... ) ...
*&---------------------------------------------------------------------*
cl_demo_output=>write( '练习三：内表操作' ).
*1> 判断内表第3行是否存在,若存在，定义结构获取第3行记录/输出，定义变量获取第3行员工姓名/输出
IF line_exists( gt_data[ 3 ] ).
  "获取第3行记录
  TRY.
      DATA(ls_data) = gt_data[ 3 ].
    CATCH cx_sy_itab_line_not_found.
  ENDTRY.
  "获取第3行员工姓名
  TRY.
      DATA(lv_name) = gt_data[ 3 ]-name.
    CATCH cx_sy_itab_line_not_found.
  ENDTRY.
  cl_demo_output=>write( ls_data ).
  cl_demo_output=>write( lv_name ).
ENDIF.

*1.1new>读取内表
*data(ls_data3) = gt_data[ id = '10' ].  "若读不到会dump,一般处理方式为try catch
data(ls_data3) = VALUE #( gt_data[ id = 10 ] OPTIONAL ).
"加上VALUE…OPTIONAL，如果读不到的话，就是一个新定义的，所以为空

*1.2new>DEFAULT如果读不到就为默认值
data(wa_def) = VALUE ty_data( id = 10 name = 'rr').
CLEAR ls_data3.
ls_data3 = VALUE #( gt_data[ id = 10 ] DEFAULT wa_def ).


*2> 获取id=3,名字是1>中员工姓名的索引值，并输出其下一行人员信息
DATA(lv_index) = line_index( gt_data[ id = 1 name = '李华' ] ).
IF lv_index NE 0 .
  CLEAR ls_data.
  TRY.
      ls_data = gt_data[ lv_index + 1 ].
    CATCH cx_sy_itab_line_not_found.
  ENDTRY.
  cl_demo_output=>write( ls_data ).
ENDIF.

*3> 将gt_data用销售主管和销售雇员分别放到两个内表并输出(使用FILTER关键字语法)
"使用多个值筛选
DATA: gt_filter TYPE SORTED TABLE OF CHAR10
                  WITH NON-UNIQUE KEY table_line.

***INitialize filter Table
gt_filter = VALUE #( ( c_xszg ) )."可以写多个

"找出满足条件的数据
DATA(gt_out) = FILTER #( gt_data IN gt_filter WHERE rank = table_line ) .
cl_demo_output=>write( gt_out ).

"找出不满足条件的数据
DATA(gt_out_t) = FILTER #( gt_data EXCEPT IN gt_filter WHERE rank = table_line ) .
cl_demo_output=>write( gt_out_t ).

*new3.1>FILTER语法-使用SORT表
TYPES: BEGIN OF ty_001,
        code TYPE char2,
        value TYPE char10,
  END OF ty_001.
DATA :itab TYPE SORTED TABLE OF ty_001 WITH NON-UNIQUE KEY code value.
DATA :itabs TYPE STANDARD TABLE OF ty_001 WITH NON-UNIQUE SORTED KEY cod COMPONENTS code value.
"初始化内表，此时被FILTER表应为SORT 或 HASH表
itab = VALUE #( ( code = '01' value = 'test01')
                ( code = '01' value = 'test001')
                ( code = '02' value = 'test02')
                ( code = '03' value = 'test003')
                ( code = '02' value = 'test021')
                ( code = '03' value = 'test031') ).
"直接Filter"找出满足条件的数据
DATA(it_filter) = FILTER #( itab WHERE  code = '01'   ).
"使用excpt 语句
DATA(it_exp) = FILTER #( itab EXCEPT WHERE code = '01' ).

*new3.2>FILTER语法
"标准表赋值
itabs = VALUE #( ( code = '01' value = 'test01')
                ( code = '01' value = 'test001')
                ( code = '02' value = 'test02')
                ( code = '03' value = 'test003')
                ( code = '02' value = 'test021')
                ( code = '03' value = 'test031') ).
"直接Filter"找出满足条件的数据
DATA(it_filters) = FILTER #( itabs USING KEY cod WHERE code = '01' ).

"显示数据
cl_demo_output=>new(
  )->next_section( |初始化内表| )->write( itab
  )->next_section( |直接Filter| )->write( it_filter
  )->next_section( |使用excpt 语句| )->write( it_exp
  )->next_section( |标准表赋值| )->write( itabs
  )->next_section( |标准表Filter| )->write( it_filters
  )->display( ).

*----------------------------------------------------------------------*
*4> a,内表行数
*   b,内表中男性员工有几位
*   c,累计内表gt_data中销售雇员工资之和
*   d,定义结构将销售雇员工资总和、最大值、平均工资、员工个数输出
生成随机数

使用cl_abap_random_int类生成整型随机数；
使用cl_abap_random_float类生成浮点随机数；
使用cl_abap_random_decfloat16类生成decfloat16类型随机数；
使用cl_abap_random_packed类生成P类型随机数；
使用cl_abap_random_packed_dec1-10类生成p类型decimal1-10随机数；
示例：​
FORM f_test_random.
  DATA:lo_random_int TYPE REF TO cl_abap_random_int.
  DATA:lo_random_float TYPE REF TO cl_abap_random_float.
  DATA:lo_random_decfloat16 TYPE REF TO cl_abap_random_decfloat16.
  DATA:lo_random_decfloat34 TYPE REF TO cl_abap_random_decfloat34.
  DATA:lo_random_packed TYPE REF TO cl_abap_random_packed.
  "其他類cl_abap_random_packed_dec1~10,返回數據類型p，decimal1~10
  DATA:lv_int TYPE i.
  DATA:lv_float TYPE float.
  DATA:lv_dec16 TYPE decfloat16.
  DATA:lv_dec34 TYPE decfloat34.
  DATA:lv_packed TYPE p LENGTH 16 DECIMALS 0.
  "返回i
  lo_random_int = cl_abap_random_int=>create( seed = 1 min = 0 max = 1000 ).
  "返回f
  lo_random_float = cl_abap_random_float=>create( seed = 1 ).
  "返回DECFLOAT16
  lo_random_decfloat16 = cl_abap_random_decfloat16=>create( seed = 1 ).
  "返回DECFLOAT34
  lo_random_decfloat34 = cl_abap_random_decfloat34=>create( seed = 1 ).
  "返回p,decimal 0
  lo_random_packed = cl_abap_random_packed=>create( seed = 1 min = 1 max = 9999 ).
  DO 2000 TIMES.
    lv_int = lo_random_int->get_next( ).
    lv_float = lo_random_float->get_next( ).
    lv_dec16 = lo_random_decfloat16->get_next( ).
    lv_dec34 = lo_random_decfloat34->get_next( ).
    WRITE:/ lv_int,lv_float,lv_dec16,lv_dec34.
  ENDDO.
ENDFORM

"内表行数
DATA(lv_lines) = lines( gt_data ).
"内表中男性员工有几位 -- 计数
DATA(lv_lines_nan) = REDUCE i( INIT x = 0
                             FOR  ls_man IN gt_data WHERE ( gender = '男' )
                          NEXT x = x + 1 ).
cl_demo_output=>write( lv_lines ).
cl_demo_output=>write( lv_lines_nan ).

"累计内表gt_data中销售雇员工资之和 --简单汇总
TYPES: ty_sal TYPE p DECIMALS 2 .
DATA(lv_sum_salary) = REDUCE ty_sal( INIT sum_sal = VALUE ty_sal(  )
                               FOR wa IN gt_data WHERE ( rank = c_rank2 )
                               NEXT sum_sal = sum_sal + wa-salary ).
cl_demo_output=>write( lv_sum_salary ).


TYPES:BEGIN OF ty_result,
        sum  TYPE p DECIMALS 2, "总和
        max  TYPE p DECIMALS 2, "最大值
        min  TYPE p DECIMALS 2, "最小值
        avg  TYPE p DECIMALS 2, "平均
        cunt TYPE i,            "记录数
      END OF ty_result.
*计算最大值最小值
DATA(ls_result) = REDUCE ty_result( INIT res =
       VALUE ty_result( min = 999999999 max = 0 )    "给一个最大值0，给一个最小值相对大的数据，然后再NEXT中比较大小
        FOR <fs_data1> IN gt_data WHERE ( rank = c_rank2 )
       NEXT res-sum = res-sum + <fs_data1>-salary       "工资总和
            res-max = nmax( val1 = res-max val2 = <fs_data1>-salary )"最高工资
            res-min = nmin( val1 = res-min val2 = <fs_data1>-salary )"最di工资
            res-cunt = res-cunt + 1                "几个销售雇员
      ).

ls_result-avg = ls_result-sum / ls_result-cunt.  "平均工资
cl_demo_output=>write( ls_result ).

*4.1>复杂汇总 -- 按照group汇总与at new ,at end ,loop group by类似
TYPES: BEGIN OF ty_002,
       code type char2,
       group type char1,
       quan type i,
  end of ty_002.
DATA itab1 TYPE TABLE OF ty_002
           WITH NON-UNIQUE SORTED KEY grp COMPONENTS group.

itab1 = VALUE #( ( code = '1' group = 'A' quan = 1 )
                 ( code = '1' group = 'A' quan = 3 )
                 ( code = '3' group = 'A' quan = 2 )
                 ( code = '2' group = 'C' quan = 4 )
                 ( code = '2' group = 'A' quan = 5 )
                 ( code = '3' group = 'B' quan = 8 )
                 ( code = '3' group = 'A' quan = 4 )
                 ( code = '1' group = 'C' quan = 2 ) ).
"按照group汇总
DATA itabg TYPE TABLE OF ty_002.
LOOP AT itab1 INTO data(ls_itab1).
  DATA(ls_check) = VALUE #( itabg[ group = ls_itab1-group ] OPTIONAL ).
  IF ls_check is NOT INITIAL.
    CONTINUE.
  ENDIF.

  data(ls_itabg) = ls_itab1.
  CLEAR ls_itabg-code.
  ls_itabg-quan = REDUCE i( INIT v = 0
                            FOR ls IN FILTER #( itab1 USING KEY grp
                            WHERE group = ls_itabg-group )
                            NEXT v = v + ls-quan ).
  APPEND ls_itabg TO itabg.
  CLEAR: ls_itabg,ls_check,ls_itab1.
ENDLOOP.

*4.2>复杂汇总 -- 按照code与group汇总
DATA itab2 TYPE TABLE OF ty_002
           WITH NON-UNIQUE SORTED KEY cod COMPONENTS code group
           WITH NON-UNIQUE SORTED KEY grp COMPONENTS group.

itab1 = VALUE #( ( code = '1' group = 'A' quan = 1 )
                 ( code = '1' group = 'A' quan = 3 )
                 ( code = '3' group = 'A' quan = 2 )
                 ( code = '2' group = 'C' quan = 4 )
                 ( code = '2' group = 'A' quan = 5 )
                 ( code = '3' group = 'B' quan = 8 )
                 ( code = '3' group = 'A' quan = 4 )
                 ( code = '1' group = 'C' quan = 2 ) ).
"按照group汇总
DATA itabcg TYPE TABLE OF ty_002.
LOOP AT itab1 INTO ls_itab1.
  ls_check = VALUE #( itabcg[ code = ls_itab1-code group = ls_itab1-group ] OPTIONAL ).
  IF ls_check is NOT INITIAL.
    CONTINUE.
  ENDIF.

  data(ls_itabcg) = ls_itab1.
  CLEAR ls_itabg-code.
  ls_itabg-quan = REDUCE i( INIT v = 0
                            FOR ls IN FILTER #( itab2 USING KEY cod
                            WHERE code = ls_itabcg-code
                              AND group = ls_itabcg-group )
                            NEXT v = v + ls-quan ).
  APPEND ls_itabcg TO itabcg.
  CLEAR: ls_itabcg,ls_check,ls_itab1.
ENDLOOP.

*&----------------------------------------------------------------------
* 练习四：OPEN SQL
*&---------------------------------------------------------------------*
cl_demo_output=>write( '练习四：' ).
*1> 工资大于等于1000为
* ... CASE WHEN sql_cond1 THEN result1
*          [WHEN sql_cond2 THEN result2]
*          [WHEN sql_cond3 THEN result3]
*            ...
*          [ELSE resultn]
*      END ...
SELECT id,name,salary,
  CASE WHEN salary GE 10000 THEN 'A'
       WHEN salary GE 5000 AND salary LT 9999  THEN 'B'
       WHEN salary LT 5000  THEN 'C'
  ELSE ' ' END AS salary_1
  FROM ytest_ng
*  GROUP BY id,name,salary
  INTO TABLE @DATA(gt_out_s).
cl_demo_output=>write( gt_out_s ).


SELECT rank,
SUM( CASE WHEN education = '本科' THEN  1 ELSE 0 END ) AS sum_ben_num ,  "--本科人数
SUM( CASE WHEN education = '专科' THEN  1 ELSE 0 END ) AS sum_zhuan_num  "--专科人数
FROM ytest_ng GROUP BY rank
INTO TABLE @DATA(gt_out_e).
cl_demo_output=>write( gt_out_e ).

*&---------------------------------------------------------------------*
*CORRESPONDING关键字
*关键字MAPPING指定不同的字段赋值
*关键字EXCEPT排除某个字段不赋值
*&---------------------------------------------------------------------*
"1.工作区中相同字段赋值，可以省去不同字段赋值的语句
DATA:BEGIN OF ls_data1,
       fd1 TYPE char10,
       fd2 TYPE char10,
       fd3 TYPE char10,
     END OF ls_data1.

DATA:BEGIN OF ls_data2,
       fd1 TYPE char10,
       fd2 TYPE char10,
       fd4 TYPE char10,
     END OF ls_data2.

ls_data1 = VALUE #( fd1 = |First|
                    fd2 = |Second|
                    fd3 = |Third| ).
"类似MOVE-CORRESPONDING
ls_data2 = CORRESPONDING #( ls_data1 ).
WRITE: / |FD1:|,ls_data2-fd1,|FD2:|,ls_data2-fd2,|FD4:|,ls_data2-fd4.
SKIP.
"相同字段赋值的基础上，指定把ls_data1-fd3赋值给ls_data2-fd4
ls_data2 = CORRESPONDING #( ls_data1 MAPPING fd4 = fd3 ).
WRITE: / |FD1:|,ls_data2-fd1,|FD2:|,ls_data2-fd2,|FD4:|,ls_data2-fd4.
SKIP.
"相同字段赋值的基础上，排除fd2初始化
ls_data2 = CORRESPONDING #( ls_data1 EXCEPT fd2 ).
WRITE: / |FD1:|,ls_data2-fd1,|FD2:|,ls_data2-fd2,|FD4:|,ls_data2-fd4.
SKIP.
"相同字段赋值的基础上，指定把ls_data1-fd3赋值给ls_data2-fd4，fd2初始化
ls_data2 = CORRESPONDING #( ls_data1 MAPPING fd4 = fd3 EXCEPT fd2 ).
WRITE: / |FD1:|,ls_data2-fd1,|FD2:|,ls_data2-fd2,|FD4:|,ls_data2-fd4.

"2.内表相同字段赋值，可以省去LOOP中READ数据再赋值，只需要将不同的字段指定好
*DATA: LT_T001 TYPE STANDARD TABLE OF ACDOCA.
*
*SELECT
*  BUKRS,
*  BELNR,
*  GJAHR,
*  BUZEI
*  FROM BSEG
*  UP TO 3 ROWS
*  INTO TABLE @DATA(LT_BSEG).
*
*"CORRESPONDING
*LT_T001 = CORRESPONDING #( LT_BSEG MAPPING RBUKRS = BUKRS
*                                           DOCLN  = BUZEI ).
*
*3.CORRESPONDING构造RANGE表，省去循环赋值，提高代码速度
RANGES: lr_rank   FOR ytest_ng-rank.
lr_rank[] = CORRESPONDING #( gt_data[] MAPPING low = rank
                                             EXCEPT * ).


SORT lr_rank BY LOW.
DELETE ADJACENT DUPLICATES FROM lr_rank COMPARING LOW.
DELETE lr_rank WHERE low is INITIAL.

lr_rank-sign = 'I'.
lr_rank-option = 'EQ'.
MODIFY lr_rank TRANSPORTING sign option WHERE low IS NOT INITIAL.

SELECT * from ytest_ng INTO TABLE gt_data WHERE rank in lr_rank.

*LCL_ALV->DISPLAY( ).
BREAK-POINT.
*--------------------------------------------------------------------*
*COND SWITCH 操作符
*在新语法中，可以使用COND、SWITCH来根据逻辑表达式或情况的不同确定指定变量的结果。
*COND SWITCH可以理解为IF CASE的替代语法，提高了代码可读性、简洁性
*--------------------------------------------------------------------*
DATA(time) = COND string(
                   WHEN sy-timlo < '120000' THEN |{ sy-timlo TIME = ISO } AM|
                   WHEN sy-timlo > '120000' THEN |{ CONV t( sy-timlo - 12 * 3600 ) TIME = ISO } PM|
                   WHEN sy-timlo = '120000' THEN |High noon|
*                   ELSE
                     ).
WRITE: time.



DATA: LV_STRING TYPE STRING VALUE 's'.
"旧
IF LV_STRING is INITIAL.
  LV_STRING = ' inittial'.
ELSEIF LV_STRING = 'K'.
  LV_STRING = 'is k'.
*ELSE.

ENDIF.

LV_STRING = COND #(
  WHEN LV_STRING IS INITIAL THEN ' inittial'
  WHEN LV_STRING = 'K'  THEN 'is k'
  ELSE LV_STRING      "如果前面条件均不满足，一定要回写LV_STRING值，否则LV_STRING值将被回写的空值覆盖
  ).
WRITE: LV_STRING.



*WHNE后面只能跟变量，类似 CASE 变量 when不同的值
DATA(a) = 11.
DATA(text) = SWITCH #( a
                       WHEN '11' THEN '11yyagd'
                       WHEN '12' THEN '12dkdkkd'
*                       ELSE
                       ).
WRITE: text.


DATA: LV_STRING1 TYPE STRING VALUE 's'.
lv_string1 = switch #( lv_string1         "如果非a b c，lv_string将被返回的空值覆盖；
  WHEN 'a' THEN 'is a'
  WHEN 'b' THEN 'is b'
  WHEN 'c' THEN 'is c'
).
WRITE: LV_STRING.

TYPES:
      BEGIN OF result,
        operand TYPE string,
        result  TYPE string,
        fdpos   TYPE sy-fdpos,
      END OF result.
    DATA results TYPE STANDARD TABLE OF result WITH EMPTY KEY.

    DATA: f1 TYPE c LENGTH 5 VALUE 'BD   ',
          f2 TYPE c LENGTH 5 VALUE 'ABCDE'.
    cl_demo_input=>new(
      )->add_field( CHANGING field = f1
      )->add_field( CHANGING field = f2 )->request( ).

    results = VALUE #( BASE results
     ( operand = 'CO'
       result     = COND #( WHEN f1 CO f2 THEN abap_true )
       fdpos      = sy-fdpos ) ).
    results = VALUE #( BASE results
     ( operand = 'CN'
       result     = COND #( WHEN f1 CN f2 THEN abap_true )
       fdpos      = sy-fdpos ) ).
    results = VALUE #( BASE results
     ( operand = 'CA'
       result     = COND #( WHEN f1 CA f2 THEN abap_true )
       fdpos      = sy-fdpos ) ).
    results = VALUE #( BASE results
     ( operand = 'NA'
       result     = COND #( WHEN f1 NA f2 THEN abap_true )
       fdpos      = sy-fdpos ) ).
    results = VALUE #( BASE results
     ( operand = 'CS'
       result     = COND #( WHEN f1 CS f2 THEN abap_true )
       fdpos      = sy-fdpos ) ).
    results = VALUE #( BASE results
     ( operand = 'NS'
       result     = COND #( WHEN f1 NS f2 THEN abap_true )
       fdpos      = sy-fdpos ) ).
    results = VALUE #( BASE results
     ( operand = 'CP'
       result     = COND #( WHEN f1 CP f2 THEN abap_true )
       fdpos      = sy-fdpos ) ).
    results = VALUE #( BASE results
     ( operand = 'NP'
       result     = COND #( WHEN f1 NP f2 THEN abap_true )
       fdpos      = sy-fdpos ) ).

    cl_demo_output=>new(
      )->write( |'{ f1 WIDTH = 5 }' operand '{ f2 WIDTH = 5 }'|
      )->display( results ).
*用于BAPI输出消息时，可用于拼接于一行显示的消息返回结果中
*    CALL FUNCTION 'BAPI_ACC_DOCUMENT_POST'
*      EXPORTING
*        DOCUMENTHEADER    = LS_DOCUMENTHEADER
*      IMPORTING
**       OBJ_TYPE          =
*        OBJ_KEY           = LV_KEY
**       OBJ_SYS           =
*      TABLES
*        ACCOUNTGL         = LT_ACCOUNTGL
*        ACCOUNTRECEIVABLE = LT_ACCOUNTRECEIVABLE
**       ACCOUNTPAYABLE    = LT_ACCOUNTPAYABLE
*        CURRENCYAMOUNT    = LT_CURRENCYAMOUNT
*        EXTENSION2        = LT_EXTENSION2
*        RETURN            = LT_RETURN.
*
*    LOOP AT LT_RETURN INTO DATA(LS_RETURN) WHERE TYPE CA 'AEX'.
*      LS_OUT-MESSAGE =
*        COND #( WHEN LS_OUT-MESSAGE = SPACE THEN LS_RETURN-MESSAGE
*                ELSE |{ LS_OUT-MESSAGE }/{ LS_RETURN-MESSAGE }| ).
*    ENDLOOP.
*--------------------------------------------------------------------*
*LOOP……GROUP BY
*--------------------------------------------------------------------*

DATA BEGIN OF gs_data1.
DATA:   sss  TYPE CHAR1,
        char TYPE char1,
        num  TYPE i ,
  end of gs_data1.

DATA: gt_data1 LIKE TABLE OF gs_data1.
DATA LV_COUNT TYPE I.
*内部追加赋值
gt_data1 = VALUE #( base gt_data1 ( sss = '1' char = 'A' )
                                ( sss = '1' char = 'A' )
                                ( sss = '2' char = 'A' )
                                ( sss = '2' char = 'A' )
                                ( sss = '3' char = 'A' )
                                ( sss = '4' char = 'C' )
                                ( sss = '5' char = 'A' )
                                ( sss = '5' char = 'A' )
                                ( sss = '2' char = 'A' )
                                ( sss = '2' char = 'A' )
                                ( sss = '3' char = 'B' )
                                ( sss = '5' char = 'A' )
                                ( sss = '5' char = 'A' )
                                ( sss = '5' char = 'A' ) ).
*--------------------------------------------------------*
"按照相同sss，char的分组排序编号给num字段赋值
*--------------------------------------------------------*
SORT gt_data1 by sss char.
LOOP AT gt_data1 INTO gs_data1 GROUP BY ( sss = gs_data1-sss   "循环时gs_data没有数据，数据通过分组到<L_MEMBER>,如果给gt_data赋值，也是用<L_MEMBER>,指针不用MODIFY
                                       char = gs_data1-char
                                       size = GROUP SIZE      "size是本组条目数量
                                      index = GROUP INDEX )   "INDEX组索引
                                      ASCENDING
                                      ASSIGNING FIELD-SYMBOL(<l_group>).  "双击可以看到，size,index以及按条件分组的条件字段值
  CLear lv_count.
  LOOP AT GROUP <l_group> ASSIGNING FIELD-SYMBOL(<l_member>).
    lv_count = lv_count + 1.
    <l_member>-num = lv_count.
  ENDLOOP.
ENDLOOP.
BREAK-POINT.



*--------------------------------------------------------*
"按照相同sss,char为一组，累加数据字段，并合并重复项
*--------------------------------------------------------*
DATA :gt_data_temp LIKE gt_data1,
      gs_data_temp LIKE gs_data1.
SORT gt_data1 by sss char.
LOOP AT gt_data1 INTO gs_data1 GROUP BY ( sss = gs_data1-sss
                                       char = gs_data1-char
                                       size = GROUP SIZE
                                      index = GROUP INDEX )
                                      ASCENDING
                                      ASSIGNING <l_group>.
  CLear lv_count.
  LOOP AT GROUP <l_group> ASSIGNING <l_member>.
    lv_count = <l_member>-num + lv_count.
    gs_data_temp = <l_member>.
  ENDLOOP.
  gs_data_temp-num = lv_count.
  APPEND gs_data_temp to gt_data_temp.
  CLEAR gs_data_temp.
ENDLOOP.
BREAK-POINT.



DATA lv_netwr TYPE vbak-netwr.
DATA: BEGIN OF lt_vbak_temp OCCURS 0,
        vkgrp LIKE vbak-vkgrp,
        vkbur LIKE vbak-vkbur,
        netwr LIKE vbak-netwr,
        waerk LIKE vbak-waerk,
      END OF lt_vbak_temp.

*DATA lt_vbak_temp TYPE TABLE OF vbak WITH HEADER LINE.
SELECT *
    FROM vbak
    INTO TABLE @DATA(lt_vbak)
   UP TO 100 ROWS.

SORT lt_vbak BY vkgrp vkbur.
LOOP AT lt_vbak INTO DATA(ls_vbak)
                GROUP BY ( vkgrp = ls_vbak-vkgrp
                           vkbur = ls_vbak-vkbur
                           waerk = ls_vbak-waerk
                           size  = GROUP SIZE
                           index = GROUP INDEX )
                           ASCENDING
                           ASSIGNING FIELD-SYMBOL(<group>).

  LOOP AT GROUP <group> ASSIGNING FIELD-SYMBOL(<member>).
    TRY.
        ADD <member>-netwr TO lv_netwr.
      CATCH cx_sy_arithmetic_error.
    ENDTRY.
    MOVE-CORRESPONDING <member> TO lt_vbak_temp.
  ENDLOOP.
  lt_vbak_temp-netwr = lv_netwr.
  APPEND lt_vbak_temp.
  CLEAR: lt_vbak_temp,lv_netwr,ls_vbak.

ENDLOOP.
cl_demo_output=>write( lt_vbak_temp[] ).

cl_demo_output=>display( ).



*&---------------------------------------------------------------------*
*& Report YTEST_NEW_GRAMMAR_AN2
*&---------------------------------------------------------------------*
*&SAP SQL杂项函数
*select 与 case结合使用最大的好处有两点，一是在显示查询结果时可以灵活
*的组织格式，二是有效避免了多次对同一个表或几个表的访问
*&---------------------------------------------------------------------*
REPORT ytest_new_grammar_an2.

*连接字符串的两种写法
DATA(lv_date1) = sy-datum && sy-uzeit.
DATA(lv_date2) = |{ sy-datum(4) - 1 }{ sy-datum+4 + 1 }|.
*cl_demo_output=>write( lv_date1 ).
*cl_demo_output=>write( lv_date2 ).

SELECT COUNT( DISTINCT carrid )
       FROM spfli
       WHERE cityto = 'NEW YORK'
       INTO @DATA(count).
*cl_demo_output=>write( count ).

SELECT *
       FROM scustom USING CLIENT '100'
       INTO TABLE @DATA(lt_customers).
*cl_demo_output=>write( lt_customers ).
*1. ... CASE operand
*           WHEN operand1 THEN result1
*          [WHEN operand2 THEN result2]
*           ...
*          [ELSE resultn]
*      END ...
DELETE FROM demo_expressions.
INSERT demo_expressions FROM TABLE @( VALUE #(
  ( id = 'x' char1 = 'aaaaa' char2 = 'bbbbb' )
  ( id = 'y' char1 = 'xxxxx' char2 = 'yyyyy' )
  ( id = 'z' char1 = 'mmmmm' char2 = 'nnnnn' ) ) )
  ACCEPTING DUPLICATE KEYS.

DATA(else) = 'fffff'.
SELECT id, char1, char2,
       CASE char1
         WHEN 'aaaaa' THEN concat( char1 , char2 )
         WHEN 'xxxxx' THEN substring( char1,1,2 )
         ELSE @else
       END AS text
       FROM demo_expressions
       INTO TABLE @DATA(lt_results1).
*cl_demo_output=>write( lt_results1 ).

"实际应用
SELECT c~bukrs, b~werks, a~budat, b~matnr, h~maktx, e~waers,
         c~lifnr, g~name1, g~land1, i~aplfz, b~meins,
         CASE b~kzabs
           WHEN 'X' THEN 'VMI'
           ELSE ' '
         END AS kzabs1,
         CASE substring( c~zterm,1,1 )
           WHEN 'B' THEN 'BWT'
           ELSE ' '
         END AS zterm1,
         SUM(
           CASE a~shkzg
             WHEN 'S' THEN ( a~dmbtr )
             WHEN 'H' THEN ( a~dmbtr * -1 )
           END ) AS dmbtr1,
         SUM(
           CASE a~shkzg
             WHEN 'S' THEN ( b~menge )
             WHEN 'H' THEN ( b~menge * -1 )
           END ) AS menge,
         CASE e~waers
           WHEN 'KRW' THEN 100
           WHEN 'JPY' THEN 100
           WHEN 'VND' THEN 100
           ELSE 1
         END AS factor
    FROM ekbe AS a
      INNER JOIN ekpo AS b
              ON b~ebeln = a~ebeln
             AND b~ebelp = a~ebelp
      INNER JOIN ekko AS c
              ON c~ebeln = a~ebeln
      INNER JOIN t001k AS f
              ON f~bwkey = b~werks
      INNER JOIN t001 AS e
              ON e~bukrs = f~bukrs
      INNER JOIN lfa1 AS g
              ON g~lifnr = c~lifnr
      INNER JOIN makt AS h
              ON h~matnr = a~matnr
      INNER JOIN zm094v AS i
              ON i~lifnr = g~lifnr
             AND i~matnr = a~matnr
             AND i~werks = a~werks
   WHERE  h~spras =  'E'
     AND b~mtart =  'ROH'
    GROUP BY c~bukrs, b~werks, a~budat, b~matnr, h~maktx,
             e~waers, c~lifnr, g~name1, g~land1, i~aplfz,
             b~meins, b~kzabs, c~zterm
  INTO TABLE @DATA(gt_vmi).
*cl_demo_output=>write( gt_vmi ).
*--------------------------------------------------------------------*
*2. ... CASE WHEN sql_cond1 THEN result1
*          [WHEN sql_cond2 THEN result2]
*          [WHEN sql_cond3 THEN result3]
*            ...
*          [ELSE resultn]
*      END ...
*CASE WHEN可以用大于，小于,SUBSTRING,CONCAT,LIKE,BETWEEN,不能用IN ,EXISTS,等条件
DELETE FROM demo_expressions.
INSERT demo_expressions FROM TABLE @( VALUE #(
  ( id = 'w' char1 = 'vvvvv' char2 = 'wwwww' dec1 = 1018 dec2 = '11.11')
  ( id = 'x' char1 = 'aaa77' char2 = 'bbbbb' dec1 = 1018 )
  ( id = 'y' char1 = 'xxxxx' char2 = 'yyyyy' dec1 = 1118 )
  ( id = 'z' char1 = 'mmmmm' char2 = 'nnnnn' dec1 = -1218 )
  ( id = 'm' char1 = 'mmmmm' char2 = 'nnnnn' dec1 = 1318 dec2 = '12.12') ) )
  ACCEPTING DUPLICATE KEYS.

SELECT id ,
  CASE WHEN char1 LIKE '%a77'           "LIKE
       THEN ( char1 && char2 )
  ELSE ( char2 && char1 )
  END AS text
  FROM demo_expressions
  INTO TABLE @DATA(lt_a77).
*cl_demo_output=>write( lt_a77 ).

SELECT id ,
  CASE WHEN substring( char1,3,3 ) = 'a77'        "SUBSTRING
       THEN ( char1 && char2 )
  ELSE concat( char2 ,char1 )                   "CONCAT
  END AS text
  FROM demo_expressions
  INTO TABLE @DATA(lt_a77_sub).
*cl_demo_output=>write( lt_a77_sub ).

SELECT id ,
*  case when ( char1 && '%' ) = 'aaa77%'
  CASE WHEN concat( char1 , '%' ) = 'aaa77%'
       THEN ( char1 && char2 )
  ELSE concat( char2 , char1 )
  END AS text
  FROM demo_expressions
  INTO TABLE @DATA(lt_a77_con).
*cl_demo_output=>write( lt_a77_con ).

SELECT id,ceil( dec2 ) AS dec2_ceil,floor( dec2 ) AS dec2_floor,
  CASE WHEN dec1  BETWEEN 1101 AND 1130   "ONLY Numerical type
       THEN 'BETWEEN'
       WHEN abs( dec1 ) = 1218 THEN 'ABS'
  ELSE 'others'
  END AS text_dec1,
  CASE WHEN ceil( dec2 ) = 12 THEN 'CEIL'
       WHEN floor( dec2 ) = 12 THEN 'FLOOR'
  ELSE 'OTHERS'
  END AS text_dec2
  FROM demo_expressions
  INTO TABLE @DATA(lt_dec).
*cl_demo_output=>write( lt_dec ).

*--------------------------------------------------------------------*

GET TIME STAMP FIELD DATA(gv_timestamp).

DELETE FROM demo_expressions.

INSERT demo_expressions FROM @(
  VALUE #( id = 'X' timestamp1 = gv_timestamp ) ).
*--------------------------------------------------------------------*
"CAST数据转换函数& div|mod|*|/|substring|concat等嵌套使用
*--------------------------------------------------------------------*
SELECT SINGLE
       FROM demo_expressions
       FIELDS CAST( CAST( div( timestamp1 , 1000000 ) AS CHAR )
                AS DATS ) AS date,
              CAST( substring( CAST( timestamp1 AS CHAR ), 9, 6 )
                AS TIMS ) AS time
       INTO @DATA(ls_expressions).
*cl_demo_output=>write( ls_expressions ).
*--------------------------------------------------------------------*
"fields与SINGLE的区别 & 日期类型与char类型显示的不同
*--------------------------------------------------------------------*
SELECT SINGLE CAST( div( timestamp1 , 1000000 )
                      AS CHAR )
                 AS date,
              CAST( substring( CAST( timestamp1
                                 AS CHAR ), 9, 6 )
                AS TIMS ) AS time
       FROM demo_expressions
       INTO @DATA(ls_expressions1).

*cl_demo_output=>write( ls_expressions1 ).

DELETE FROM demo_expressions.
INSERT demo_expressions FROM TABLE @(
  VALUE #( ( id = 'X' num1 = 111 )
           ( id = 'Y' num1 = 222 )
           ( id = 'Z' num1 = 333 ) ) ).
*--------------------------------------------------------------------*
"WHERE 中等号左右两边都可以使用CAST,SUBSTRING,CONCAT,*,+，-等
*--------------------------------------------------------------------*
*SELECT FROM demo_expressions
*       FIELDS id, num1
*       WHERE CAST( num1 AS CHAR ) LIKE '2%'
*       INTO TABLE @DATA(result).

select t1~matnr,
       werks,
       charg,
       cuobj
  from mchb as t1
  left outer join inob as t2
  on substring( t2~objek , 1, 18 )  = t1~matnr  "1-18位 是物料号
  and substring( t2~objek, 41,10 )  = t1~charg  "41~50位 是批次
  where t2~klart = '023'
  into table @data(lt_mchb).

SELECT *
  FROM bkpf "AS t1
  WHERE substring( awkey , 1, 10 )  = '1'
  AND   substring( awkey , 11, 4 )  = 1
  INTO TABLE @data(gt_outt) .

SELECT *
  FROM bkpf "AS t1
  WHERE awkey = '___5555_'       "假设共8位，想取4-7位数据为5555的
  AND   substring( awkey , 1, 4 )  = 1
  INTO TABLE @data(gt_outtt) .



"SELECT…聚合函数&CAST
SELECT carrid, SUM( CAST( price AS DEC( 20,2  ) )  ) AS price1
       FROM ysflight_oolav_1
       WHERE carrid = 'JL'
       GROUP BY carrid
       INTO TABLE @DATA(lt_ysflight_oolav_1).
*cl_demo_output=>write( lt_ysflight_oolav_1 ).

*--------------------------------------------------------------------*
*case…when& concat& substring& cast嵌套使用
*CAST,SUBSTRING,CONCAT,*,+，-等也可以在CASE WHEN，THEN,WHERE关键字等号左右两边均可使用，
* CASE WHEN中小数怎么处理，可以给左边取数乘以10

*CAST也可用于同类型修改长度
*--------------------------------------------------------------------*
"Get Goal
  GET TIME STAMP FIELD data(lv_start_time)."获取当前系统的时间戳
SELECT a~zcustg,
       b~name,
       a~goal_rate AS goal_deci,
       a~gjahr,
       " goal_rate = 0
  CASE WHEN a~goal_rate = 0 THEN ' '
       "goal_rate >=1
       WHEN a~goal_rate >= 1
       THEN concat( substring( CAST( ( a~goal_rate * 100 ) AS CHAR ),
       1,3 ), '%' )
      "0 < goal_rate < 0.1
      WHEN ( a~goal_rate * 10 ) < 1 AND a~goal_rate > 0
      THEN concat( substring( CAST( ( a~goal_rate * 100 ) AS CHAR ),
      1,1 ), '%' )
      "0.1 <= goal_rate < 1
      ELSE concat( substring( CAST( ( a~goal_rate * 100 ) AS CHAR ),
      1,2 ), '%' )
  END AS goal
      FROM zsa6202 AS a
      INNER JOIN zsa6001 AS b
              ON a~zcustg = b~zcustg
      ORDER BY a~zcustg, b~name
      INTO TABLE @DATA(lt_data) .
  GET TIME STAMP FIELD data(lv_end_time).
  DATA(lv_rfc_time) = lv_end_time - lv_start_time.  "

  GET TIME STAMP FIELD data(lv_start_time1)."获取当前系统的时间戳
SELECT a~zcustg,
       b~name,
       a~goal_rate AS goal_deci,
       a~gjahr,
       a~goal_rate
      FROM zsa6202 AS a
      INNER JOIN zsa6001 AS b
              ON a~zcustg = b~zcustg
      ORDER BY a~zcustg, b~name
      INTO TABLE @DATA(lt_data1) .
  GET TIME STAMP FIELD data(lv_end_time1).
  DATA(lv_rfc_time1) = lv_end_time1 - lv_start_time1.  "
*cl_demo_output=>write( lt_data ).
cl_demo_output=>write( lv_rfc_time ).
cl_demo_output=>write( lv_rfc_time1 ).

*--------------------------------------------------------------------*
*除了CAST、CONCAT之外，ROUND,  LPAD, LENGTH, REPLACE, RIGHT, RTRIM,SUBSTRING
*等函数也可以使用,杂项函数COALESCE 也可以使用，但是最多255个表达式
*--------------------------------------------------------------------*
"LPAD可用于补0，或者补任何字符
SELECT CONCAT( CONCAT( carrid,
                       LPAD( carrname,30,' ' ) ),
               LPAD( url,40,' ' ) ) AS line
       FROM scarr
       INTO TABLE @DATA(result1).

cl_demo_output=>write( result1 ).

    DELETE FROM demo_expressions.
    INSERT demo_expressions FROM TABLE @( VALUE #(
      ( id = 'X'
        char1 = ' 0123'
        char2 = ' 4567' ) ) ).

    SELECT SINGLE
           char1 AS text1,
           char2 AS text2,
           CONCAT(    char1,char2 )     AS concat,
           LENGTH(    char1        )    AS length,    "字符串长度,包含空格长度
"从左边去除字符串的所有空格，类似SHIFT <l_tbtco>-periode LEFT DELETING LEADING '0'.不止为0，可以为其他字符
           LTRIM(     char1,' '    )    AS ltrim,
           LPAD( char1,10,'0' )         AS LPAD,      "补0，或者补任何其他字符至10位
           REPLACE(   char1,'12','__' ) AS replace,   "替换
           RIGHT(     char1,3 )         as right,     "从右边截取,且包含空格
           RTRIM(     char1,'3' )       AS rtrim,     ""该函数功能是在arg的右边查找char字符，如果找到，则去掉；
           SUBSTRING( char1,3,3 )       AS substring
           FROM demo_expressions
           INTO @DATA(result2).

    cl_demo_output=>write( result2 ).
*--------------------------------------------------------------------*
*REPLACE
*RIGHT( arg, len )    从右往左截取固定长度
*RTRIM( arg, char )  该函数功能是在arg的右边查找char字符，如果找到，则去掉；
*COALESCE( sql_exp1, sql_exp2, ..., sql_expn )   凝聚函数，该函数的功能是将参数中的第一个不为空的参数返回来

*可以用于不同的表取值
*--------------------------------------------------------------------*
SELECT matnr,
replace( vpsta,'VE','HU' ) AS str,
       vpsta,
       ernam
FROM mara
WHERE vpsta LIKE 'KCV%'
INTO TABLE @DATA(gt_out)  UP TO 10 ROWS.


SELECT matnr,
     right( matkl,3 ) AS str,
     matkl
FROM mara
WHERE vpsta LIKE 'KCV%'
INTO TABLE @DATA(gt_out1)  UP TO 10 ROWS.

*其实该语法也可以用于inner join,从而可以解决在inner join时字段长度不一致的问题
SELECT a~*
FROM vbrp AS a
  INNER JOIN ekpo AS b ON a~aubel = b~ebeln
AND right( a~aupos,5 ) = b~ebelp
WHERE b~ebeln <> ''
INTO TABLE @DATA(gt_out2).

*该函数的功能是将参数中的第一个不为空的参数返回来,或者是将参数中第一个成立的表达式的值返回到别名
*比如请假，先找cell长审批，再找part长，再找group长，再找team长，也可以innerjoin等
SELECT
  FROM mara
FIELDS matnr,
    coalesce(  CASE vpsta WHEN 'KDG' THEN 'HUJIE' END,
               CASE vpsta WHEN 'KDA' THEN 'LAIMIN'
               ELSE 'DUODUO'
                END ) AS str,
                         vpsta
WHERE vpsta LIKE 'KD%'
INTO TABLE @DATA(lt_out) UP TO 10 ROWS.

SELECT LFA1~LIFNR,
COALESCE( EKKO~LIFNR, EKKO~EBELN, '无采购订单' ) as vendor
FROM LFA1
INNER JOIN EKKO ON LFA1~LIFNR = EKKO~LIFNR
INTO TABLE @DATA(LT_OUT1).



cl_demo_output=>display( ).