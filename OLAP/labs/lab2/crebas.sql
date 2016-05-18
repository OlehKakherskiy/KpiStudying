/*==============================================================*/
/* Database name:  SALE                                         */
/* DBMS name:      ORACLE Version 11g                           */
/* Created on:     18.05.2016 23:47:12                          */
/*==============================================================*/


alter table INVOICE
   drop constraint FK_INVOICE_REFERENCE_PAYMENT_;

alter table INVOICE
   drop constraint FK_INVOICE_REFERENCE_STUFF;

alter table INVOICE_DETAIL
   drop constraint FK_INVOICE__REFERENCE_INVOICE;

alter table INVOICE_DETAIL
   drop constraint FK_INVOICE__REFERENCE_PRODUCT;

alter table PRODUCT
   drop constraint FK_PRODUCT_REFERENCE_SUPPLIER;

alter table PRODUCT
   drop constraint FK_PRODUCT_REFERENCE_PRODUCT_;

alter table PRODUCT
   drop constraint FK_PRODUCT_REFERENCE_UNIT;

alter table STORE
   drop constraint FK_STORE_REFERENCE_TYPE_OPE;

alter table STORE
   drop constraint FK_STORE_REFERENCE_PRODUCT;

alter table STUFF
   drop constraint FK_STUFF_REFERENCE_POSITION;

drop index "Reference_12_FK";

drop index "Reference_5_FK";

drop table INVOICE cascade constraints;

drop index "Reference_7_FK";

drop index "Reference_6_FK";

drop table INVOICE_DETAIL cascade constraints;

drop table PAYMENT_TYPE cascade constraints;

drop table POSITION cascade constraints;

drop index "Reference_9_FK";

drop index "Reference_3_FK";

drop index "Reference_2_FK";

drop table PRODUCT cascade constraints;

drop table PRODUCT_TYPE cascade constraints;

drop index "Reference_11_FK";

drop index "Reference_10_FK";

drop table STORE cascade constraints;

drop index "Reference_8_FK";

drop table STUFF cascade constraints;

drop table SUPPLIER cascade constraints;

drop table TYPE_OPER cascade constraints;

drop table UNIT cascade constraints;

/*==============================================================*/
/* Database: SALE                                               */
/*==============================================================*/
create database SALE;

/*==============================================================*/
/* Table: INVOICE                                               */
/*==============================================================*/
create table INVOICE 
(
   "id_invoice"         NUMBER               not null,
   "id_stuff"           NUMBER               not null,
   "id_type"            NUMBER               not null,
   "purchase_time"      DATE                 default SYSDATE not null,
   constraint PK_INVOICE primary key ("id_invoice")
);

comment on table INVOICE is
'Інформація про оплату.';

comment on column INVOICE."id_invoice" is
'Унікальний ідентифікатор оплати.';

comment on column INVOICE."id_stuff" is
'Інікальний ідентифікатор робітника.';

comment on column INVOICE."id_type" is
'Унікальний ідентифікатор типу оплати.';

comment on column INVOICE."purchase_time" is
'Час виконання оплати.';

/*==============================================================*/
/* Index: "Reference_5_FK"                                      */
/*==============================================================*/
create index "Reference_5_FK" on INVOICE (
   "id_stuff" ASC
);

/*==============================================================*/
/* Index: "Reference_12_FK"                                     */
/*==============================================================*/
create index "Reference_12_FK" on INVOICE (
   "id_type" ASC
);

/*==============================================================*/
/* Table: INVOICE_DETAIL                                        */
/*==============================================================*/
create table INVOICE_DETAIL 
(
   "id_invoice"         NUMBER               not null,
   "quantity"           NUMBER(10,0)         default 0 not null
      constraint CKC_QUANTITY_INVOICE_ check ("quantity" >= 0),
   "description"        VARCHAR2(500)        not null,
   "id_invoice_detail"  NUMBER               not null,
   "id_product"         NUMBER               not null,
   constraint PK_INVOICE_DETAIL primary key ("id_invoice_detail")
);

comment on table INVOICE_DETAIL is
'Оплата за продукти.';

comment on column INVOICE_DETAIL."quantity" is
'Кількість товару.';

comment on column INVOICE_DETAIL."description" is
'Опис придбання.';

comment on column INVOICE_DETAIL."id_product" is
'Унікальний ідентифікатор товару.';

/*==============================================================*/
/* Index: "Reference_6_FK"                                      */
/*==============================================================*/
create index "Reference_6_FK" on INVOICE_DETAIL (
   "id_invoice" ASC
);

/*==============================================================*/
/* Index: "Reference_7_FK"                                      */
/*==============================================================*/
create index "Reference_7_FK" on INVOICE_DETAIL (
   "id_product" ASC
);

/*==============================================================*/
/* Table: PAYMENT_TYPE                                          */
/*==============================================================*/
create table PAYMENT_TYPE 
(
   "id_type"            NUMBER               not null,
   "payment_type_name"  varchar2(128)        not null,
   "description"        varchar2(256)        default 'There is no description about this payment type',
   constraint PK_PAYMENT_TYPE primary key ("id_type")
);

comment on table PAYMENT_TYPE is
'Інформація про тип оплати.';

comment on column PAYMENT_TYPE."id_type" is
'Унікальний ідентифікатор типу оплати.';

comment on column PAYMENT_TYPE."payment_type_name" is
'Назва типу оплати.';

comment on column PAYMENT_TYPE."description" is
'Опис типу полати.';

/*==============================================================*/
/* Table: POSITION                                              */
/*==============================================================*/
create table POSITION 
(
   "id_position"        NUMBER               not null,
   "position_name"      varchar2(128)        not null,
   "salary"             NUMBER               default 0 not null
      constraint CKC_SALARY_POSITION check ("salary" >= 0),
   "description"        VARCHAR2(1024)       default 'There is no description about this position',
   constraint PK_POSITION primary key ("id_position")
);

comment on table POSITION is
'Опис посад.';

comment on column POSITION."id_position" is
'Унікальний ідентифікатор посади.';

comment on column POSITION."position_name" is
'Назва позиції.';

comment on column POSITION."salary" is
'Заробітна плата.';

comment on column POSITION."description" is
'Опис посади.';

/*==============================================================*/
/* Table: PRODUCT                                               */
/*==============================================================*/
create table PRODUCT 
(
   "id_product"         NUMBER               not null,
   "id_supplier"        NUMBER               not null,
   "id_product_type"    NUMBER               not null,
   "id_unit"            number               not null,
   "product_name"       varchar2(128)        not null,
   "description"        varchar2(128)        default 'There is no description for this product',
   "price"              INTEGER              default 0 not null
      constraint CKC_PRICE_PRODUCT check ("price" >= 0),
   constraint PK_PRODUCT primary key ("id_product")
);

comment on table PRODUCT is
'Інофрмація про товари.';

comment on column PRODUCT."id_product" is
'Унікальний ідентифікатор товару.';

comment on column PRODUCT."id_supplier" is
'Унікальний ідентифікатор постачальника.';

comment on column PRODUCT."id_product_type" is
'Унікальний ідентифікатор типу продукту.';

comment on column PRODUCT."product_name" is
'Назва товару.';

comment on column PRODUCT."description" is
'Опис товару.';

comment on column PRODUCT."price" is
'Ціна товару.';

/*==============================================================*/
/* Index: "Reference_2_FK"                                      */
/*==============================================================*/
create index "Reference_2_FK" on PRODUCT (
   "id_supplier" ASC
);

/*==============================================================*/
/* Index: "Reference_3_FK"                                      */
/*==============================================================*/
create index "Reference_3_FK" on PRODUCT (
   "id_product_type" ASC
);

/*==============================================================*/
/* Index: "Reference_9_FK"                                      */
/*==============================================================*/
create index "Reference_9_FK" on PRODUCT (
   "id_unit" ASC
);

/*==============================================================*/
/* Table: PRODUCT_TYPE                                          */
/*==============================================================*/
create table PRODUCT_TYPE 
(
   "id_product_type"    NUMBER               not null,
   "product_type_name"  varchar2(128)        not null,
   constraint PK_PRODUCT_TYPE primary key ("id_product_type")
);

comment on table PRODUCT_TYPE is
'Інформація про типи продуктів.';

comment on column PRODUCT_TYPE."id_product_type" is
'Унікальний ідентифікатор типу продукту.';

comment on column PRODUCT_TYPE."product_type_name" is
'Назва типу продукту.';

/*==============================================================*/
/* Table: STORE                                                 */
/*==============================================================*/
create table STORE 
(
   "id_store"           NUMBER               not null,
   "id_oper_type"       INTEGER              not null,
   "id_product"         NUMBER               not null,
   "shelf"              varchar2(10)         not null,
   "date_oper"          DATE                 not null,
   "quantity"           NUMBER               not null,
   constraint PK_STORE primary key ("id_store")
);

comment on table STORE is
'Інформація про склад';

comment on column STORE."id_store" is
'Унікальний ідентифікатор сховища.';

comment on column STORE."id_oper_type" is
'ідентифікатор операції.';

comment on column STORE."id_product" is
'Унікальний ідентифікатор товару.';

comment on column STORE."shelf" is
'Номер полиці складу.';

comment on column STORE."date_oper" is
'дата операції';

comment on column STORE."quantity" is
'Кількітсь товару.';

/*==============================================================*/
/* Index: "Reference_10_FK"                                     */
/*==============================================================*/
create index "Reference_10_FK" on STORE (
   "id_oper_type" ASC
);

/*==============================================================*/
/* Index: "Reference_11_FK"                                     */
/*==============================================================*/
create index "Reference_11_FK" on STORE (
   "id_product" ASC
);

/*==============================================================*/
/* Table: STUFF                                                 */
/*==============================================================*/
create table STUFF 
(
   "id_stuff"           NUMBER               not null,
   "id_position"        NUMBER               not null,
   "name"               VARCHAR2(64)         not null,
   "surname"            VARCHAR2(64)         not null,
   "phone"              varchar2(64)         not null,
   "address"            varchar2(256)        not null,
   constraint PK_STUFF primary key ("id_stuff")
);

comment on table STUFF is
'Інфнормація про працюючий персонал.';

comment on column STUFF."id_stuff" is
'Інікальний ідентифікатор робітника.';

comment on column STUFF."id_position" is
'Унікальний ідентифікатор посади.';

comment on column STUFF."name" is
'Імя працівника.';

comment on column STUFF."surname" is
'Прізвище працівника.';

comment on column STUFF."phone" is
'Контактний номер телефону.';

comment on column STUFF."address" is
'Адреса працівника.';

/*==============================================================*/
/* Index: "Reference_8_FK"                                      */
/*==============================================================*/
create index "Reference_8_FK" on STUFF (
   "id_position" ASC
);

/*==============================================================*/
/* Table: SUPPLIER                                              */
/*==============================================================*/
create table SUPPLIER 
(
   "id_supplier"        NUMBER               not null,
   "supplier_name"      varchar2(128)        not null,
   "supplier_info"      varchar2(1024)       default 'There is no information about this supplier',
   constraint PK_SUPPLIER primary key ("id_supplier")
);

comment on table SUPPLIER is
'Інформація про постачальників.';

comment on column SUPPLIER."id_supplier" is
'Унікальний ідентифікатор постачальника.';

comment on column SUPPLIER."supplier_name" is
'Назва постачальника.';

comment on column SUPPLIER."supplier_info" is
'Інфомація про постачальника. Адреса, контактний телефон.';

/*==============================================================*/
/* Table: TYPE_OPER                                             */
/*==============================================================*/
create table TYPE_OPER 
(
   "id_oper_type"       INTEGER              not null,
   "name_oper"          VARCHAR2(3 BYTE)     not null,
   "description"        VARCHAR(100)         not null,
   constraint PK_TYPE_OPER primary key ("id_oper_type")
);

comment on table TYPE_OPER is
'Довідник операцій.';

comment on column TYPE_OPER."id_oper_type" is
'ідентифікатор операції.';

comment on column TYPE_OPER."name_oper" is
'Назва операції.';

comment on column TYPE_OPER."description" is
'Опис типу операції.
';

/*==============================================================*/
/* Table: UNIT                                                  */
/*==============================================================*/
create table UNIT 
(
   "id_unit"            number               not null,
   "unit_name"          varchar2(128)        not null,
   "description"        varchar2(512)        not null,
   constraint PK_UNIT primary key ("id_unit")
);

alter table INVOICE
   add constraint FK_INVOICE_REFERENCE_PAYMENT_ foreign key ("id_type")
      references PAYMENT_TYPE ("id_type");

alter table INVOICE
   add constraint FK_INVOICE_REFERENCE_STUFF foreign key ("id_stuff")
      references STUFF ("id_stuff");

alter table INVOICE_DETAIL
   add constraint FK_INVOICE__REFERENCE_INVOICE foreign key ("id_invoice")
      references INVOICE ("id_invoice")
      on delete cascade;

alter table INVOICE_DETAIL
   add constraint FK_INVOICE__REFERENCE_PRODUCT foreign key ("id_product")
      references PRODUCT ("id_product");

alter table PRODUCT
   add constraint FK_PRODUCT_REFERENCE_SUPPLIER foreign key ("id_supplier")
      references SUPPLIER ("id_supplier");

alter table PRODUCT
   add constraint FK_PRODUCT_REFERENCE_PRODUCT_ foreign key ("id_product_type")
      references PRODUCT_TYPE ("id_product_type");

alter table PRODUCT
   add constraint FK_PRODUCT_REFERENCE_UNIT foreign key ("id_unit")
      references UNIT ("id_unit");

alter table STORE
   add constraint FK_STORE_REFERENCE_TYPE_OPE foreign key ("id_oper_type")
      references TYPE_OPER ("id_oper_type");

alter table STORE
   add constraint FK_STORE_REFERENCE_PRODUCT foreign key ("id_product")
      references PRODUCT ("id_product");

alter table STUFF
   add constraint FK_STUFF_REFERENCE_POSITION foreign key ("id_position")
      references POSITION ("id_position");

