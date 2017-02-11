# MySQL-Front 3.2  (Build 7.11)
/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES 'cp1251' */;

CREATE TABLE `account_params` (
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `PARAM_ID` varchar(32) NOT NULL,
  `PRIORITY` int(11) NOT NULL,
  PRIMARY KEY (`ACCOUNT_ID`,`PARAM_ID`),
  KEY `PARAM_ID` (`PARAM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `account_presentations` (
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `OPERATION_ID` varchar(32) NOT NULL,
  `PRESENTATION_ID` varchar(32) NOT NULL,
  `CONDITIONS` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`ACCOUNT_ID`,`VIEW_ID`,`TYPE_ID`,`OPERATION_ID`),
  KEY `VIEW_ID` (`VIEW_ID`),
  KEY `TYPE_ID` (`TYPE_ID`),
  KEY `OPERATION_ID` (`OPERATION_ID`),
  KEY `PRESENTATION_ID` (`PRESENTATION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `account_roles` (
  `ROLE_ID` varchar(32) NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  PRIMARY KEY (`ROLE_ID`,`ACCOUNT_ID`),
  KEY `ACCOUNT_ID` (`ACCOUNT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `accounts` (
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `PASSWORD` varchar(100) DEFAULT NULL,
  `DESCRIPTION` varchar(250) DEFAULT NULL,
  `DB_PASSWORD` varchar(100) DEFAULT NULL,
  `IS_ROLE` int(11) DEFAULT NULL,
  `USER_NAME` varchar(100) DEFAULT NULL,
  `FIRM_ID` varchar(32) DEFAULT NULL,
  `FIRM_NAME` varchar(200) DEFAULT NULL,
  `LOCKED` int(11) DEFAULT NULL,
  `AUTO_CREATED` int(11) DEFAULT NULL,
  `SURNAME` varchar(100) DEFAULT NULL,
  `NAME` varchar(100) DEFAULT NULL,
  `PATRONYMIC` varchar(100) DEFAULT NULL,
  `PHONE` varchar(100) DEFAULT NULL,
  `EMAIL` varchar(100) DEFAULT NULL,
  `DB_USER_NAME` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`ACCOUNT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `application_interfaces` (
  `APPLICATION_ID` varchar(32) NOT NULL,
  `INTERFACE_ID` varchar(32) NOT NULL,
  `PRIORITY` int(11) NOT NULL,
  `AUTO_RUN` int(11) NOT NULL,
  PRIMARY KEY (`APPLICATION_ID`,`INTERFACE_ID`),
  KEY `INTERFACE_ID` (`INTERFACE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `applications` (
  `APPLICATION_ID` varchar(32) NOT NULL,
  `NAME` varchar(100) NOT NULL,
  `DESCRIPTION` varchar(250) DEFAULT NULL,
  `LOCKED` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`APPLICATION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `articles` (
  `id` int(5) NOT NULL AUTO_INCREMENT,
  `date` date DEFAULT NULL,
  `type` int(1) DEFAULT NULL COMMENT 'тип (1 - статья, 2- новость)',
  `partition` varchar(40) DEFAULT NULL COMMENT 'Раздел (рубрика)',
  `caption` varchar(200) DEFAULT NULL COMMENT 'Заголовок',
  `announcement` varchar(220) DEFAULT NULL COMMENT 'Анонс',
  `descr` text COMMENT 'Полное содержание новости',
  `source_name` varchar(120) DEFAULT NULL COMMENT 'Наименование источника',
  `source_link` varchar(100) DEFAULT NULL COMMENT 'Ссылка на источник',
  `status` int(1) DEFAULT NULL COMMENT 'Статус',
  `sort` int(6) DEFAULT NULL COMMENT 'Для сортировки',
  `author` varchar(200) DEFAULT NULL COMMENT 'Автор добавления',
  `author_date` date DEFAULT NULL COMMENT 'Дата добавления',
  `author_time` time DEFAULT NULL COMMENT 'Время добавления',
  `author_update` varchar(200) DEFAULT NULL COMMENT 'Автор изменения',
  `update_date` date DEFAULT NULL COMMENT 'Дата последнего изменения',
  `update_time` time DEFAULT NULL COMMENT 'Время последнего изменения',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=41 DEFAULT CHARSET=cp1251 COMMENT='Статьи';

CREATE TABLE `articles_photos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `articles_id` int(11) DEFAULT NULL COMMENT 'Идентификатор объекта',
  `photo` varchar(50) DEFAULT NULL COMMENT 'Ссылка на фотографию',
  `comment` varchar(200) DEFAULT NULL COMMENT 'Комментарий к фотке',
  `sort` int(6) DEFAULT NULL COMMENT 'Порядок сортировки',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=25 DEFAULT CHARSET=cp1251 COMMENT='Фотографии для статей и новостей';

CREATE TABLE `articles_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type_id` int(11) DEFAULT NULL COMMENT 'Идентификатор типа',
  `type_value` varchar(40) DEFAULT NULL,
  `sort` int(6) DEFAULT NULL COMMENT 'Порядок сортировки',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=cp1251 COMMENT='Виды';

CREATE TABLE `column_params` (
  `COLUMN_ID` varchar(32) NOT NULL,
  `PARAM_ID` varchar(32) NOT NULL,
  `PRIORITY` int(11) NOT NULL,
  `STRING_BEFORE` varchar(100) DEFAULT NULL,
  `STRING_AFTER` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`COLUMN_ID`,`PARAM_ID`),
  KEY `PARAM_ID` (`PARAM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `columns` (
  `COLUMN_ID` varchar(32) NOT NULL,
  `NAME` varchar(100) NOT NULL,
  `DESCRIPTION` varchar(250) DEFAULT NULL,
  `HTML_HEAD` varchar(100) DEFAULT NULL,
  `HTML_DATA` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`COLUMN_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `del` (
  `name` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `firm_types` (
  `FIRM_TYPE_ID` varchar(32) NOT NULL,
  `NAME` varchar(100) NOT NULL,
  `DESCRIPTION` varchar(250) DEFAULT NULL,
  `PRIORITY` int(11) NOT NULL,
  PRIMARY KEY (`FIRM_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `firms` (
  `FIRM_ID` varchar(32) NOT NULL,
  `FIRM_TYPE_ID` varchar(32) NOT NULL,
  `PARENT_ID` varchar(32) DEFAULT NULL,
  `SMALL_NAME` varchar(250) NOT NULL,
  `FULL_NAME` varchar(250) NOT NULL,
  `INN` varchar(12) DEFAULT NULL,
  `PAYMENT_ACCOUNT` varchar(20) DEFAULT NULL,
  `BANK` varchar(250) DEFAULT NULL,
  `BIK` varchar(20) DEFAULT NULL,
  `CORR_ACCOUNT` varchar(20) DEFAULT NULL,
  `LEGAL_ADDRESS` varchar(250) DEFAULT NULL,
  `POST_ADDRESS` varchar(250) DEFAULT NULL,
  `PHONE` varchar(250) DEFAULT NULL,
  `FAX` varchar(250) DEFAULT NULL,
  `EMAIL` varchar(100) DEFAULT NULL,
  `SITE` varchar(100) DEFAULT NULL,
  `OKONH` varchar(20) DEFAULT NULL,
  `OKPO` varchar(20) DEFAULT NULL,
  `KPP` varchar(20) DEFAULT NULL,
  `DIRECTOR` varchar(250) DEFAULT NULL,
  `ACCOUNTANT` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`FIRM_ID`),
  KEY `FIRM_TYPE_ID` (`FIRM_TYPE_ID`),
  KEY `PARENT_ID` (`PARENT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `interfaces` (
  `INTERFACE_ID` varchar(32) NOT NULL,
  `NAME` varchar(100) NOT NULL,
  `DESCRIPTION` varchar(250) DEFAULT NULL,
  `INTERNAL` int(11) NOT NULL,
  `INTERFACE_CLASS` varchar(100) DEFAULT NULL,
  `MODULE_NAME` varchar(100) DEFAULT NULL,
  `MODULE_INTERFACE` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`INTERFACE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `notepad` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `ACCOUNT_ID` varchar(32) DEFAULT NULL,
  `SID` varchar(32) DEFAULT NULL,
  `OBJECT_ID` varchar(32) DEFAULT NULL,
  `TYPE_ID` varchar(32) DEFAULT NULL,
  `OPERATION_ID` varchar(32) DEFAULT NULL,
  `DATE_NOTEPAD` date DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=cp1251 COMMENT='Блокнот';

CREATE TABLE `object_params` (
  `OBJECT_PARAM_ID` varchar(32) NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `PARAM_ID` varchar(32) NOT NULL,
  `OBJECT_ID` varchar(32) NOT NULL,
  `DATE_CREATE` datetime NOT NULL,
  `VALUE` longblob NOT NULL,
  `DESCRIPTION` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`OBJECT_PARAM_ID`),
  KEY `ACCOUNT_ID` (`ACCOUNT_ID`),
  KEY `PARAM_ID` (`PARAM_ID`),
  KEY `OBJECT_ID` (`OBJECT_ID`),
  KEY `IDX_OBJECT_PARAMS_1` (`DATE_CREATE`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `objects` (
  `OBJECT_ID` varchar(32) NOT NULL,
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `DATE_BEGIN` datetime NOT NULL,
  `DATE_END` datetime DEFAULT NULL,
  `STATUS` int(11) NOT NULL DEFAULT '0',
  `OPERATION_ID` varchar(32) NOT NULL,
  PRIMARY KEY (`OBJECT_ID`),
  KEY `VIEW_ID` (`VIEW_ID`),
  KEY `TYPE_ID` (`TYPE_ID`),
  KEY `ACCOUNT_ID` (`ACCOUNT_ID`),
  KEY `OPERATION_ID` (`OPERATION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `objects_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sid` varchar(32) DEFAULT NULL,
  `partition_id` int(2) DEFAULT NULL COMMENT '1- справочник, 2-авто (бренды)',
  `name` varchar(100) DEFAULT NULL COMMENT 'Наименование',
  `sort` int(5) DEFAULT NULL COMMENT 'Порядок сортировки',
  `count_objects` int(11) DEFAULT NULL,
  `status` int(1) DEFAULT NULL COMMENT '1- нормальный, 0 - не отображать на сайте',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=cp1251 COMMENT='Тпы объектов';

CREATE TABLE `operations` (
  `OPERATION_ID` varchar(32) NOT NULL,
  `NAME` varchar(100) NOT NULL,
  `DESCRIPTION` varchar(250) DEFAULT NULL,
  `PRIORITY` int(11) NOT NULL,
  PRIMARY KEY (`OPERATION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `param_value_depends` (
  `WHAT_PARAM_VALUE_ID` varchar(32) NOT NULL,
  `FROM_PARAM_VALUE_ID` varchar(32) NOT NULL,
  PRIMARY KEY (`WHAT_PARAM_VALUE_ID`,`FROM_PARAM_VALUE_ID`),
  KEY `FROM_PARAM_VALUE_ID` (`FROM_PARAM_VALUE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `param_value_variants` (
  `PARAM_VALUE_ID` varchar(32) NOT NULL,
  `VALUE` varchar(100) NOT NULL,
  `PRIORITY` int(11) NOT NULL,
  PRIMARY KEY (`PARAM_VALUE_ID`,`VALUE`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `param_values` (
  `PARAM_VALUE_ID` varchar(32) NOT NULL,
  `PARAM_ID` varchar(32) NOT NULL,
  `NAME` varchar(100) NOT NULL,
  `DESCRIPTION` varchar(250) DEFAULT NULL,
  `PRIORITY` int(11) NOT NULL,
  PRIMARY KEY (`PARAM_VALUE_ID`),
  KEY `PARAM_ID` (`PARAM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `params` (
  `PARAM_ID` varchar(32) NOT NULL,
  `NAME` varchar(100) NOT NULL,
  `DESCRIPTION` varchar(250) DEFAULT NULL,
  `PARAM_TYPE` int(11) NOT NULL,
  `ELEMENT_TYPE` int(11) DEFAULT NULL,
  `IS_NULL` int(11) NOT NULL,
  `FORMAT` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`PARAM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `permissions` (
  `PERMISSION_ID` varchar(32) NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `INTERFACE_ID` varchar(32) NOT NULL,
  `RIGHT_ACCESS` varchar(250) NOT NULL,
  `VALUE` varchar(250) NOT NULL,
  PRIMARY KEY (`PERMISSION_ID`),
  KEY `ACCOUNT_ID` (`ACCOUNT_ID`),
  KEY `INTERFACE_ID` (`INTERFACE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `premises` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `premises_id` int(11) NOT NULL DEFAULT '0',
  `release_id` int(11) NOT NULL DEFAULT '0',
  `operation_id` int(11) NOT NULL DEFAULT '0',
  `region_name` varchar(250) DEFAULT NULL COMMENT 'Район',
  `street_name` varchar(250) DEFAULT NULL COMMENT 'Улица',
  `delivery_date` date DEFAULT NULL COMMENT 'Дата поступления',
  `town_name` varchar(250) DEFAULT NULL COMMENT 'Город',
  `type_building_name` varchar(250) DEFAULT NULL COMMENT 'Из чего дом',
  `countroom_name` varchar(250) DEFAULT NULL COMMENT 'Количество комнат',
  `general_area` float(15,2) DEFAULT NULL COMMENT 'Площадь общая',
  `type_apartment_name` varchar(250) DEFAULT NULL COMMENT 'Планировка',
  `price` float(9,2) DEFAULT NULL,
  `unit_price_name` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `release_id` (`release_id`),
  KEY `operation_id` (`operation_id`),
  KEY `region_name` (`region_name`),
  KEY `street_name` (`street_name`),
  KEY `countroom_name` (`countroom_name`)
) ENGINE=MyISAM AUTO_INCREMENT=431626 DEFAULT CHARSET=cp1251;

CREATE TABLE `presentation_columns` (
  `PRESENTATION_ID` varchar(32) NOT NULL,
  `COLUMN_ID` varchar(32) NOT NULL,
  `PRIORITY` int(11) NOT NULL,
  `COLUMN_GROUP` int(11) NOT NULL DEFAULT '0',
  `STRING_BEFORE` varchar(100) DEFAULT NULL,
  `STRING_AFTER` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`PRESENTATION_ID`,`COLUMN_ID`),
  KEY `COLUMN_ID` (`COLUMN_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `presentations` (
  `PRESENTATION_ID` varchar(32) NOT NULL,
  `NAME` varchar(100) NOT NULL,
  `DESCRIPTION` varchar(250) DEFAULT NULL,
  `TABLE_NAME` varchar(100) NOT NULL,
  `SORTING` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`PRESENTATION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `profiles` (
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `APPLICATION_ID` varchar(32) NOT NULL,
  `PROFILE` longblob,
  PRIMARY KEY (`ACCOUNT_ID`,`APPLICATION_ID`),
  KEY `APPLICATION_ID` (`APPLICATION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `questions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `account_id` varchar(32) DEFAULT NULL,
  `type_id` int(5) DEFAULT NULL COMMENT 'Тип вопроса (раздел)',
  `date_q` date DEFAULT NULL,
  `time_q` time DEFAULT NULL,
  `author` varchar(50) DEFAULT NULL,
  `email` varchar(30) DEFAULT NULL,
  `subject` varchar(250) DEFAULT NULL COMMENT 'тема сообщения',
  `question` text,
  `date_answ` date DEFAULT NULL,
  `time_answ` time DEFAULT NULL,
  `author_answ` varchar(30) DEFAULT NULL,
  `answer` text,
  `status` int(1) DEFAULT NULL COMMENT '1- поступила, 2-обработана, 3-опубликована на сайте',
  `job_title` varchar(100) DEFAULT NULL COMMENT 'Должность',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=167 DEFAULT CHARSET=cp1251 ROW_FORMAT=DYNAMIC COMMENT='Вопрос-ответ';

CREATE TABLE `questions_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type_id` int(5) DEFAULT NULL,
  `type_value` varchar(150) DEFAULT NULL,
  `sort` int(2) DEFAULT NULL COMMENT 'Порядок сортировки',
  `status` int(1) DEFAULT NULL COMMENT 'Статус',
  `user_id` int(11) DEFAULT NULL COMMENT 'Ид специалиста',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=cp1251 COMMENT='Тип вопроса';

CREATE TABLE `s_buy_apartments` (
  `OBJECT_ID` varchar(32) NOT NULL,
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `OPERATION_ID` varchar(32) NOT NULL,
  `DATE_BEGIN` datetime NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `USER_NAME` varchar(100) DEFAULT NULL,
  `PHONE` varchar(100) DEFAULT NULL,
  `Комн` longtext,
  `Район` longtext,
  `План.` longtext,
  `Ориентир` longtext,
  `Улица` longtext,
  `Пл, м2` longtext,
  `Тип` longtext,
  `Этаж` longtext,
  `Цена` longtext,
  PRIMARY KEY (`OBJECT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `s_buy_bases` (
  `OBJECT_ID` varchar(32) NOT NULL,
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `OPERATION_ID` varchar(32) NOT NULL,
  `DATE_BEGIN` datetime NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `USER_NAME` varchar(100) DEFAULT NULL,
  `PHONE` varchar(100) DEFAULT NULL,
  `Населенный пункт` longtext,
  `Общая площадь` longtext,
  `Высота потолка` longtext,
  `Тип` longtext,
  `Рядом находится` longtext,
  `Цена` longtext,
  PRIMARY KEY (`OBJECT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `s_buy_garages` (
  `OBJECT_ID` varchar(32) NOT NULL,
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `OPERATION_ID` varchar(32) NOT NULL,
  `DATE_BEGIN` datetime NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `USER_NAME` varchar(100) DEFAULT NULL,
  `PHONE` varchar(100) DEFAULT NULL,
  `Ориентир` longtext,
  `Улица` longtext,
  `Общая площадь` longtext,
  `Тип` longtext,
  `Высота потолка` longtext,
  `Дополнительные строения` longtext,
  `Цена` longtext,
  PRIMARY KEY (`OBJECT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `s_buy_land_free_purpose` (
  `OBJECT_ID` varchar(32) NOT NULL,
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `OPERATION_ID` varchar(32) NOT NULL,
  `DATE_BEGIN` datetime NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `USER_NAME` varchar(100) DEFAULT NULL,
  `PHONE` varchar(100) DEFAULT NULL,
  `Ориентир` longtext,
  `Улица` longtext,
  `Общая площадь` longtext,
  `Объект находится в` longtext,
  `Рядом находится` longtext,
  `Цена` longtext,
  PRIMARY KEY (`OBJECT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `s_buy_land_out_point` (
  `OBJECT_ID` varchar(32) NOT NULL,
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `OPERATION_ID` varchar(32) NOT NULL,
  `DATE_BEGIN` datetime NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `USER_NAME` varchar(100) DEFAULT NULL,
  `PHONE` varchar(100) DEFAULT NULL,
  `Территория` longtext,
  `Населенный пункт` longtext,
  `Удаленность` longtext,
  `Категория` longtext,
  `Назначение` longtext,
  `Участок` longtext,
  `Рядом находится` longtext,
  `Цена` longtext,
  PRIMARY KEY (`OBJECT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `s_buy_new_buildings` (
  `OBJECT_ID` varchar(32) NOT NULL,
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `OPERATION_ID` varchar(32) NOT NULL,
  `DATE_BEGIN` datetime NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `USER_NAME` varchar(100) DEFAULT NULL,
  `PHONE` varchar(100) DEFAULT NULL,
  `Комн` longtext,
  `Район` longtext,
  `Ориентир` longtext,
  `Улица` longtext,
  `Пл, м2` longtext,
  `Тип` longtext,
  `Этаж` longtext,
  `Цена` longtext,
  PRIMARY KEY (`OBJECT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `s_buy_offices` (
  `OBJECT_ID` varchar(32) NOT NULL,
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `OPERATION_ID` varchar(32) NOT NULL,
  `DATE_BEGIN` datetime NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `USER_NAME` varchar(100) DEFAULT NULL,
  `PHONE` varchar(100) DEFAULT NULL,
  `Комн` longtext,
  `Общая площадь` longtext,
  `Ориентир` longtext,
  `Улица` longtext,
  `Объект находится в` longtext,
  `Этаж` longtext,
  `Тел` longtext,
  `Интернет` longtext,
  `Цена` longtext,
  PRIMARY KEY (`OBJECT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `s_buy_private_houses` (
  `OBJECT_ID` varchar(32) NOT NULL,
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `OPERATION_ID` varchar(32) NOT NULL,
  `DATE_BEGIN` datetime NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `USER_NAME` varchar(100) DEFAULT NULL,
  `PHONE` varchar(100) DEFAULT NULL,
  `Ориентир` longtext,
  `Улица` longtext,
  `Пл, м2` longtext,
  `Общая площадь` longtext,
  `Тип` longtext,
  `Этажность дома` longtext,
  `Участок` longtext,
  `Дополнительные строения` longtext,
  `Цена` longtext,
  PRIMARY KEY (`OBJECT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `s_buy_productions` (
  `OBJECT_ID` varchar(32) NOT NULL,
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `OPERATION_ID` varchar(32) NOT NULL,
  `DATE_BEGIN` datetime NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `USER_NAME` varchar(100) DEFAULT NULL,
  `PHONE` varchar(100) DEFAULT NULL,
  `Населенный пункт` longtext,
  `Общая площадь` longtext,
  `Высота потолка` longtext,
  `Тип` longtext,
  `Рядом находится` longtext,
  `Цена` longtext,
  PRIMARY KEY (`OBJECT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `s_buy_restaurants` (
  `OBJECT_ID` varchar(32) NOT NULL,
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `OPERATION_ID` varchar(32) NOT NULL,
  `DATE_BEGIN` datetime NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `USER_NAME` varchar(100) DEFAULT NULL,
  `PHONE` varchar(100) DEFAULT NULL,
  `Ориентир` longtext,
  `Улица` longtext,
  `Общая площадь` longtext,
  `Объект находится в` longtext,
  `Рядом находится` longtext,
  `Тип` longtext,
  `Высота потолка` longtext,
  `Цена` longtext,
  PRIMARY KEY (`OBJECT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `s_buy_town_houses` (
  `OBJECT_ID` varchar(32) NOT NULL,
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `OPERATION_ID` varchar(32) NOT NULL,
  `DATE_BEGIN` datetime NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `USER_NAME` varchar(100) DEFAULT NULL,
  `PHONE` varchar(100) DEFAULT NULL,
  `Ориентир` longtext,
  `Улица` longtext,
  `Пл, м2` longtext,
  `Общая площадь` longtext,
  `Тип` longtext,
  `Этажность дома` longtext,
  `Участок` longtext,
  `Рядом находится` longtext,
  `Цена` longtext,
  PRIMARY KEY (`OBJECT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `s_buy_trade_premises` (
  `OBJECT_ID` varchar(32) NOT NULL,
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `OPERATION_ID` varchar(32) NOT NULL,
  `DATE_BEGIN` datetime NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `USER_NAME` varchar(100) DEFAULT NULL,
  `PHONE` varchar(100) DEFAULT NULL,
  `Ориентир` longtext,
  `Улица` longtext,
  `Общая площадь` longtext,
  `Объект находится в` longtext,
  `Рядом находится` longtext,
  `Высота потолка` longtext,
  `Этажность дома` longtext,
  `Цена` longtext,
  PRIMARY KEY (`OBJECT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `s_change_apartments` (
  `OBJECT_ID` varchar(32) NOT NULL,
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `OPERATION_ID` varchar(32) NOT NULL,
  `DATE_BEGIN` datetime NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `USER_NAME` varchar(100) DEFAULT NULL,
  `PHONE` varchar(100) DEFAULT NULL,
  `Комн` longtext,
  `Район` longtext,
  `План.` longtext,
  `Ориентир` longtext,
  `Улица` longtext,
  `Пл, м2` longtext,
  `Тип` longtext,
  `Этаж` longtext,
  `Цена` longtext,
  PRIMARY KEY (`OBJECT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `s_change_bases` (
  `OBJECT_ID` varchar(32) NOT NULL,
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `OPERATION_ID` varchar(32) NOT NULL,
  `DATE_BEGIN` datetime NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `USER_NAME` varchar(100) DEFAULT NULL,
  `PHONE` varchar(100) DEFAULT NULL,
  `Населенный пункт` longtext,
  `Общая площадь` longtext,
  `Высота потолка` longtext,
  `Тип` longtext,
  `Рядом находится` longtext,
  `Цена` longtext,
  PRIMARY KEY (`OBJECT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `s_change_garages` (
  `OBJECT_ID` varchar(32) NOT NULL,
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `OPERATION_ID` varchar(32) NOT NULL,
  `DATE_BEGIN` datetime NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `USER_NAME` varchar(100) DEFAULT NULL,
  `PHONE` varchar(100) DEFAULT NULL,
  `Ориентир` longtext,
  `Улица` longtext,
  `Общая площадь` longtext,
  `Тип` longtext,
  `Высота потолка` longtext,
  `Дополнительные строения` longtext,
  `Цена` longtext,
  PRIMARY KEY (`OBJECT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `s_change_land_free_purpose` (
  `OBJECT_ID` varchar(32) NOT NULL,
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `OPERATION_ID` varchar(32) NOT NULL,
  `DATE_BEGIN` datetime NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `USER_NAME` varchar(100) DEFAULT NULL,
  `PHONE` varchar(100) DEFAULT NULL,
  `Ориентир` longtext,
  `Улица` longtext,
  `Общая площадь` longtext,
  `Объект находится в` longtext,
  `Рядом находится` longtext,
  `Цена` longtext,
  PRIMARY KEY (`OBJECT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `s_change_land_out_point` (
  `OBJECT_ID` varchar(32) NOT NULL,
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `OPERATION_ID` varchar(32) NOT NULL,
  `DATE_BEGIN` datetime NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `USER_NAME` varchar(100) DEFAULT NULL,
  `PHONE` varchar(100) DEFAULT NULL,
  `Территория` longtext,
  `Населенный пункт` longtext,
  `Удаленность` longtext,
  `Категория` longtext,
  `Назначение` longtext,
  `Участок` longtext,
  `Рядом находится` longtext,
  `Цена` longtext,
  PRIMARY KEY (`OBJECT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `s_change_new_buildings` (
  `OBJECT_ID` varchar(32) NOT NULL,
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `OPERATION_ID` varchar(32) NOT NULL,
  `DATE_BEGIN` datetime NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `USER_NAME` varchar(100) DEFAULT NULL,
  `PHONE` varchar(100) DEFAULT NULL,
  `Комн` longtext,
  `Район` longtext,
  `Ориентир` longtext,
  `Улица` longtext,
  `Пл, м2` longtext,
  `Тип` longtext,
  `Этаж` longtext,
  `Цена` longtext,
  PRIMARY KEY (`OBJECT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `s_change_offices` (
  `OBJECT_ID` varchar(32) NOT NULL,
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `OPERATION_ID` varchar(32) NOT NULL,
  `DATE_BEGIN` datetime NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `USER_NAME` varchar(100) DEFAULT NULL,
  `PHONE` varchar(100) DEFAULT NULL,
  `Комн` longtext,
  `Общая площадь` longtext,
  `Ориентир` longtext,
  `Улица` longtext,
  `Объект находится в` longtext,
  `Этаж` longtext,
  `Тел` longtext,
  `Интернет` longtext,
  `Цена` longtext,
  PRIMARY KEY (`OBJECT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `s_change_private_houses` (
  `OBJECT_ID` varchar(32) NOT NULL,
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `OPERATION_ID` varchar(32) NOT NULL,
  `DATE_BEGIN` datetime NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `USER_NAME` varchar(100) DEFAULT NULL,
  `PHONE` varchar(100) DEFAULT NULL,
  `Ориентир` longtext,
  `Улица` longtext,
  `Пл, м2` longtext,
  `Общая площадь` longtext,
  `Тип` longtext,
  `Этажность дома` longtext,
  `Участок` longtext,
  `Дополнительные строения` longtext,
  `Цена` longtext,
  PRIMARY KEY (`OBJECT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `s_change_productions` (
  `OBJECT_ID` varchar(32) NOT NULL,
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `OPERATION_ID` varchar(32) NOT NULL,
  `DATE_BEGIN` datetime NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `USER_NAME` varchar(100) DEFAULT NULL,
  `PHONE` varchar(100) DEFAULT NULL,
  `Населенный пункт` longtext,
  `Общая площадь` longtext,
  `Высота потолка` longtext,
  `Тип` longtext,
  `Рядом находится` longtext,
  `Цена` longtext,
  PRIMARY KEY (`OBJECT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `s_change_restaurants` (
  `OBJECT_ID` varchar(32) NOT NULL,
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `OPERATION_ID` varchar(32) NOT NULL,
  `DATE_BEGIN` datetime NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `USER_NAME` varchar(100) DEFAULT NULL,
  `PHONE` varchar(100) DEFAULT NULL,
  `Ориентир` longtext,
  `Улица` longtext,
  `Общая площадь` longtext,
  `Объект находится в` longtext,
  `Рядом находится` longtext,
  `Тип` longtext,
  `Высота потолка` longtext,
  `Цена` longtext,
  PRIMARY KEY (`OBJECT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `s_change_town_houses` (
  `OBJECT_ID` varchar(32) NOT NULL,
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `OPERATION_ID` varchar(32) NOT NULL,
  `DATE_BEGIN` datetime NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `USER_NAME` varchar(100) DEFAULT NULL,
  `PHONE` varchar(100) DEFAULT NULL,
  `Ориентир` longtext,
  `Улица` longtext,
  `Пл, м2` longtext,
  `Общая площадь` longtext,
  `Тип` longtext,
  `Этажность дома` longtext,
  `Участок` longtext,
  `Рядом находится` longtext,
  `Цена` longtext,
  PRIMARY KEY (`OBJECT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `s_change_trade_premises` (
  `OBJECT_ID` varchar(32) NOT NULL,
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `OPERATION_ID` varchar(32) NOT NULL,
  `DATE_BEGIN` datetime NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `USER_NAME` varchar(100) DEFAULT NULL,
  `PHONE` varchar(100) DEFAULT NULL,
  `Ориентир` longtext,
  `Улица` longtext,
  `Общая площадь` longtext,
  `Объект находится в` longtext,
  `Рядом находится` longtext,
  `Высота потолка` longtext,
  `Этажность дома` longtext,
  `Цена` longtext,
  PRIMARY KEY (`OBJECT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `s_deliver_apartments` (
  `OBJECT_ID` varchar(32) NOT NULL,
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `OPERATION_ID` varchar(32) NOT NULL,
  `DATE_BEGIN` datetime NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `USER_NAME` varchar(100) DEFAULT NULL,
  `PHONE` varchar(100) DEFAULT NULL,
  `Комн` longtext,
  `Район` longtext,
  `План.` longtext,
  `Ориентир` longtext,
  `Улица` longtext,
  `Пл, м2` longtext,
  `Тип` longtext,
  `Этаж` longtext,
  `Цена` longtext,
  PRIMARY KEY (`OBJECT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `s_deliver_bases` (
  `OBJECT_ID` varchar(32) NOT NULL,
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `OPERATION_ID` varchar(32) NOT NULL,
  `DATE_BEGIN` datetime NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `USER_NAME` varchar(100) DEFAULT NULL,
  `PHONE` varchar(100) DEFAULT NULL,
  `Населенный пункт` longtext,
  `Общая площадь` longtext,
  `Высота потолка` longtext,
  `Тип` longtext,
  `Рядом находится` longtext,
  `Цена` longtext,
  PRIMARY KEY (`OBJECT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `s_deliver_garages` (
  `OBJECT_ID` varchar(32) NOT NULL,
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `OPERATION_ID` varchar(32) NOT NULL,
  `DATE_BEGIN` datetime NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `USER_NAME` varchar(100) DEFAULT NULL,
  `PHONE` varchar(100) DEFAULT NULL,
  `Ориентир` longtext,
  `Улица` longtext,
  `Общая площадь` longtext,
  `Тип` longtext,
  `Высота потолка` longtext,
  `Дополнительные строения` longtext,
  `Цена` longtext,
  PRIMARY KEY (`OBJECT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `s_deliver_land_free_purpose` (
  `OBJECT_ID` varchar(32) NOT NULL,
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `OPERATION_ID` varchar(32) NOT NULL,
  `DATE_BEGIN` datetime NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `USER_NAME` varchar(100) DEFAULT NULL,
  `PHONE` varchar(100) DEFAULT NULL,
  `Ориентир` longtext,
  `Улица` longtext,
  `Общая площадь` longtext,
  `Объект находится в` longtext,
  `Рядом находится` longtext,
  `Цена` longtext,
  PRIMARY KEY (`OBJECT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `s_deliver_land_out_point` (
  `OBJECT_ID` varchar(32) NOT NULL,
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `OPERATION_ID` varchar(32) NOT NULL,
  `DATE_BEGIN` datetime NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `USER_NAME` varchar(100) DEFAULT NULL,
  `PHONE` varchar(100) DEFAULT NULL,
  `Территория` longtext,
  `Населенный пункт` longtext,
  `Удаленность` longtext,
  `Категория` longtext,
  `Назначение` longtext,
  `Участок` longtext,
  `Рядом находится` longtext,
  `Цена` longtext,
  PRIMARY KEY (`OBJECT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `s_deliver_new_buildings` (
  `OBJECT_ID` varchar(32) NOT NULL,
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `OPERATION_ID` varchar(32) NOT NULL,
  `DATE_BEGIN` datetime NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `USER_NAME` varchar(100) DEFAULT NULL,
  `PHONE` varchar(100) DEFAULT NULL,
  `Комн` longtext,
  `Район` longtext,
  `Ориентир` longtext,
  `Улица` longtext,
  `Пл, м2` longtext,
  `Тип` longtext,
  `Этаж` longtext,
  `Цена` longtext,
  PRIMARY KEY (`OBJECT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `s_deliver_offices` (
  `OBJECT_ID` varchar(32) NOT NULL,
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `OPERATION_ID` varchar(32) NOT NULL,
  `DATE_BEGIN` datetime NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `USER_NAME` varchar(100) DEFAULT NULL,
  `PHONE` varchar(100) DEFAULT NULL,
  `Комн` longtext,
  `Общая площадь` longtext,
  `Ориентир` longtext,
  `Улица` longtext,
  `Объект находится в` longtext,
  `Этаж` longtext,
  `Тел` longtext,
  `Интернет` longtext,
  `Цена` longtext,
  PRIMARY KEY (`OBJECT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `s_deliver_private_houses` (
  `OBJECT_ID` varchar(32) NOT NULL,
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `OPERATION_ID` varchar(32) NOT NULL,
  `DATE_BEGIN` datetime NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `USER_NAME` varchar(100) DEFAULT NULL,
  `PHONE` varchar(100) DEFAULT NULL,
  `Ориентир` longtext,
  `Улица` longtext,
  `Пл, м2` longtext,
  `Общая площадь` longtext,
  `Тип` longtext,
  `Этажность дома` longtext,
  `Участок` longtext,
  `Дополнительные строения` longtext,
  `Цена` longtext,
  PRIMARY KEY (`OBJECT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `s_deliver_productions` (
  `OBJECT_ID` varchar(32) NOT NULL,
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `OPERATION_ID` varchar(32) NOT NULL,
  `DATE_BEGIN` datetime NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `USER_NAME` varchar(100) DEFAULT NULL,
  `PHONE` varchar(100) DEFAULT NULL,
  `Населенный пункт` longtext,
  `Общая площадь` longtext,
  `Высота потолка` longtext,
  `Тип` longtext,
  `Рядом находится` longtext,
  `Цена` longtext,
  PRIMARY KEY (`OBJECT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `s_deliver_restaurants` (
  `OBJECT_ID` varchar(32) NOT NULL,
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `OPERATION_ID` varchar(32) NOT NULL,
  `DATE_BEGIN` datetime NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `USER_NAME` varchar(100) DEFAULT NULL,
  `PHONE` varchar(100) DEFAULT NULL,
  `Ориентир` longtext,
  `Улица` longtext,
  `Общая площадь` longtext,
  `Объект находится в` longtext,
  `Рядом находится` longtext,
  `Тип` longtext,
  `Высота потолка` longtext,
  `Цена` longtext,
  PRIMARY KEY (`OBJECT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `s_deliver_town_houses` (
  `OBJECT_ID` varchar(32) NOT NULL,
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `OPERATION_ID` varchar(32) NOT NULL,
  `DATE_BEGIN` datetime NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `USER_NAME` varchar(100) DEFAULT NULL,
  `PHONE` varchar(100) DEFAULT NULL,
  `Ориентир` longtext,
  `Улица` longtext,
  `Пл, м2` longtext,
  `Общая площадь` longtext,
  `Тип` longtext,
  `Этажность дома` longtext,
  `Участок` longtext,
  `Рядом находится` longtext,
  `Цена` longtext,
  PRIMARY KEY (`OBJECT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `s_deliver_trade_premises` (
  `OBJECT_ID` varchar(32) NOT NULL,
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `OPERATION_ID` varchar(32) NOT NULL,
  `DATE_BEGIN` datetime NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `USER_NAME` varchar(100) DEFAULT NULL,
  `PHONE` varchar(100) DEFAULT NULL,
  `Ориентир` longtext,
  `Улица` longtext,
  `Общая площадь` longtext,
  `Объект находится в` longtext,
  `Рядом находится` longtext,
  `Высота потолка` longtext,
  `Этажность дома` longtext,
  `Цена` longtext,
  PRIMARY KEY (`OBJECT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `s_sell_apartments` (
  `OBJECT_ID` varchar(32) NOT NULL,
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `OPERATION_ID` varchar(32) NOT NULL,
  `DATE_BEGIN` datetime NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `USER_NAME` varchar(100) DEFAULT NULL,
  `PHONE` varchar(100) DEFAULT NULL,
  `Комн` longtext,
  `Район` longtext,
  `План.` longtext,
  `Ориентир` longtext,
  `Улица` longtext,
  `Пл, м2` longtext,
  `Тип` longtext,
  `Этаж` longtext,
  `Цена` longtext,
  PRIMARY KEY (`OBJECT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `s_sell_bases` (
  `OBJECT_ID` varchar(32) NOT NULL,
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `OPERATION_ID` varchar(32) NOT NULL,
  `DATE_BEGIN` datetime NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `USER_NAME` varchar(100) DEFAULT NULL,
  `PHONE` varchar(100) DEFAULT NULL,
  `Населенный пункт` longtext,
  `Общая площадь` longtext,
  `Высота потолка` longtext,
  `Тип` longtext,
  `Рядом находится` longtext,
  `Цена` longtext,
  PRIMARY KEY (`OBJECT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `s_sell_buildings` (
  `OBJECT_ID` varchar(32) NOT NULL,
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `OPERATION_ID` varchar(32) NOT NULL,
  `DATE_BEGIN` datetime NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `USER_NAME` varchar(100) DEFAULT NULL,
  `PHONE` varchar(100) DEFAULT NULL,
  `Ориентир` longtext,
  `Улица` longtext,
  `Этажность дома` longtext,
  `Пл, м2` longtext,
  `Общая площадь` longtext,
  `Тип` longtext,
  `Рядом находится` longtext,
  `Цена` longtext,
  PRIMARY KEY (`OBJECT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `s_sell_datchas` (
  `OBJECT_ID` varchar(32) NOT NULL,
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `OPERATION_ID` varchar(32) NOT NULL,
  `DATE_BEGIN` datetime NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `USER_NAME` varchar(100) DEFAULT NULL,
  `PHONE` varchar(100) DEFAULT NULL,
  `Территория` longtext,
  `Населенный пункт` longtext,
  `Удаленность` longtext,
  `Этажность дома` longtext,
  `Комн` longtext,
  `Общая площадь` longtext,
  `Участок` longtext,
  `Пл, м2` longtext,
  `Дополнительные строения` longtext,
  `Рядом находится` longtext,
  `Цена` longtext,
  PRIMARY KEY (`OBJECT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `s_sell_garages` (
  `OBJECT_ID` varchar(32) NOT NULL,
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `OPERATION_ID` varchar(32) NOT NULL,
  `DATE_BEGIN` datetime NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `USER_NAME` varchar(100) DEFAULT NULL,
  `PHONE` varchar(100) DEFAULT NULL,
  `Ориентир` longtext,
  `Улица` longtext,
  `Общая площадь` longtext,
  `Тип` longtext,
  `Высота потолка` longtext,
  `Дополнительные строения` longtext,
  `Цена` longtext,
  PRIMARY KEY (`OBJECT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `s_sell_land_free_purpose` (
  `OBJECT_ID` varchar(32) NOT NULL,
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `OPERATION_ID` varchar(32) NOT NULL,
  `DATE_BEGIN` datetime NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `USER_NAME` varchar(100) DEFAULT NULL,
  `PHONE` varchar(100) DEFAULT NULL,
  `Ориентир` longtext,
  `Улица` longtext,
  `Общая площадь` longtext,
  `Объект находится в` longtext,
  `Рядом находится` longtext,
  `Цена` longtext,
  PRIMARY KEY (`OBJECT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `s_sell_land_in_point` (
  `OBJECT_ID` varchar(32) NOT NULL,
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `OPERATION_ID` varchar(32) NOT NULL,
  `DATE_BEGIN` datetime NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `USER_NAME` varchar(100) DEFAULT NULL,
  `PHONE` varchar(100) DEFAULT NULL,
  `Ориентир` longtext,
  `Улица` longtext,
  `Участок` longtext,
  `Категория` longtext,
  `Назначение` longtext,
  `Рядом находится` longtext,
  `Цена` longtext,
  PRIMARY KEY (`OBJECT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `s_sell_land_out_point` (
  `OBJECT_ID` varchar(32) NOT NULL,
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `OPERATION_ID` varchar(32) NOT NULL,
  `DATE_BEGIN` datetime NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `USER_NAME` varchar(100) DEFAULT NULL,
  `PHONE` varchar(100) DEFAULT NULL,
  `Территория` longtext,
  `Населенный пункт` longtext,
  `Удаленность` longtext,
  `Категория` longtext,
  `Назначение` longtext,
  `Участок` longtext,
  `Рядом находится` longtext,
  `Цена` longtext,
  PRIMARY KEY (`OBJECT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `s_sell_new_buildings` (
  `OBJECT_ID` varchar(32) NOT NULL,
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `OPERATION_ID` varchar(32) NOT NULL,
  `DATE_BEGIN` datetime NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `USER_NAME` varchar(100) DEFAULT NULL,
  `PHONE` varchar(100) DEFAULT NULL,
  `Комн` longtext,
  `Район` longtext,
  `Ориентир` longtext,
  `Улица` longtext,
  `Пл, м2` longtext,
  `Тип` longtext,
  `Этаж` longtext,
  `Цена` longtext,
  PRIMARY KEY (`OBJECT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `s_sell_offices` (
  `OBJECT_ID` varchar(32) NOT NULL,
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `OPERATION_ID` varchar(32) NOT NULL,
  `DATE_BEGIN` datetime NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `USER_NAME` varchar(100) DEFAULT NULL,
  `PHONE` varchar(100) DEFAULT NULL,
  `Комн` longtext,
  `Общая площадь` longtext,
  `Ориентир` longtext,
  `Улица` longtext,
  `Объект находится в` longtext,
  `Этаж` longtext,
  `Тел` longtext,
  `Интернет` longtext,
  `Цена` longtext,
  PRIMARY KEY (`OBJECT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `s_sell_outside_houses` (
  `OBJECT_ID` varchar(32) NOT NULL,
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `OPERATION_ID` varchar(32) NOT NULL,
  `DATE_BEGIN` datetime NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `USER_NAME` varchar(100) DEFAULT NULL,
  `PHONE` varchar(100) DEFAULT NULL,
  `Населенный пункт` longtext,
  `Удаленность` longtext,
  `Этажность дома` longtext,
  `Тип` longtext,
  `Пл, м2` longtext,
  `Общая площадь` longtext,
  `Участок` longtext,
  `Дополнительные строения` longtext,
  `Рядом находится` longtext,
  `Цена` longtext,
  PRIMARY KEY (`OBJECT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `s_sell_private_houses` (
  `OBJECT_ID` varchar(32) NOT NULL,
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `OPERATION_ID` varchar(32) NOT NULL,
  `DATE_BEGIN` datetime NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `USER_NAME` varchar(100) DEFAULT NULL,
  `PHONE` varchar(100) DEFAULT NULL,
  `Ориентир` longtext,
  `Улица` longtext,
  `Пл, м2` longtext,
  `Общая площадь` longtext,
  `Тип` longtext,
  `Этажность дома` longtext,
  `Участок` longtext,
  `Дополнительные строения` longtext,
  `Цена` longtext,
  PRIMARY KEY (`OBJECT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `s_sell_productions` (
  `OBJECT_ID` varchar(32) NOT NULL,
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `OPERATION_ID` varchar(32) NOT NULL,
  `DATE_BEGIN` datetime NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `USER_NAME` varchar(100) DEFAULT NULL,
  `PHONE` varchar(100) DEFAULT NULL,
  `Населенный пункт` longtext,
  `Общая площадь` longtext,
  `Высота потолка` longtext,
  `Тип` longtext,
  `Рядом находится` longtext,
  `Цена` longtext,
  PRIMARY KEY (`OBJECT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `s_sell_restaurants` (
  `OBJECT_ID` varchar(32) NOT NULL,
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `OPERATION_ID` varchar(32) NOT NULL,
  `DATE_BEGIN` datetime NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `USER_NAME` varchar(100) DEFAULT NULL,
  `PHONE` varchar(100) DEFAULT NULL,
  `Ориентир` longtext,
  `Улица` longtext,
  `Общая площадь` longtext,
  `Объект находится в` longtext,
  `Рядом находится` longtext,
  `Тип` longtext,
  `Высота потолка` longtext,
  `Цена` longtext,
  PRIMARY KEY (`OBJECT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `s_sell_town_houses` (
  `OBJECT_ID` varchar(32) NOT NULL,
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `OPERATION_ID` varchar(32) NOT NULL,
  `DATE_BEGIN` datetime NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `USER_NAME` varchar(100) DEFAULT NULL,
  `PHONE` varchar(100) DEFAULT NULL,
  `Ориентир` longtext,
  `Улица` longtext,
  `Пл, м2` longtext,
  `Общая площадь` longtext,
  `Тип` longtext,
  `Этажность дома` longtext,
  `Участок` longtext,
  `Рядом находится` longtext,
  `Цена` longtext,
  PRIMARY KEY (`OBJECT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `s_sell_trade_premises` (
  `OBJECT_ID` varchar(32) NOT NULL,
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `OPERATION_ID` varchar(32) NOT NULL,
  `DATE_BEGIN` datetime NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `USER_NAME` varchar(100) DEFAULT NULL,
  `PHONE` varchar(100) DEFAULT NULL,
  `Ориентир` longtext,
  `Улица` longtext,
  `Общая площадь` longtext,
  `Объект находится в` longtext,
  `Рядом находится` longtext,
  `Высота потолка` longtext,
  `Этажность дома` longtext,
  `Цена` longtext,
  PRIMARY KEY (`OBJECT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `s_shoot_apartments` (
  `OBJECT_ID` varchar(32) NOT NULL,
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `OPERATION_ID` varchar(32) NOT NULL,
  `DATE_BEGIN` datetime NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `USER_NAME` varchar(100) DEFAULT NULL,
  `PHONE` varchar(100) DEFAULT NULL,
  `Комн` longtext,
  `Район` longtext,
  `План.` longtext,
  `Ориентир` longtext,
  `Улица` longtext,
  `Пл, м2` longtext,
  `Тип` longtext,
  `Этаж` longtext,
  `Цена` longtext,
  PRIMARY KEY (`OBJECT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `s_shoot_bases` (
  `OBJECT_ID` varchar(32) NOT NULL,
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `OPERATION_ID` varchar(32) NOT NULL,
  `DATE_BEGIN` datetime NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `USER_NAME` varchar(100) DEFAULT NULL,
  `PHONE` varchar(100) DEFAULT NULL,
  `Населенный пункт` longtext,
  `Общая площадь` longtext,
  `Высота потолка` longtext,
  `Тип` longtext,
  `Рядом находится` longtext,
  `Цена` longtext,
  PRIMARY KEY (`OBJECT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `s_shoot_garages` (
  `OBJECT_ID` varchar(32) NOT NULL,
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `OPERATION_ID` varchar(32) NOT NULL,
  `DATE_BEGIN` datetime NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `USER_NAME` varchar(100) DEFAULT NULL,
  `PHONE` varchar(100) DEFAULT NULL,
  `Ориентир` longtext,
  `Улица` longtext,
  `Общая площадь` longtext,
  `Тип` longtext,
  `Высота потолка` longtext,
  `Дополнительные строения` longtext,
  `Цена` longtext,
  PRIMARY KEY (`OBJECT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `s_shoot_land_free_purpose` (
  `OBJECT_ID` varchar(32) NOT NULL,
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `OPERATION_ID` varchar(32) NOT NULL,
  `DATE_BEGIN` datetime NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `USER_NAME` varchar(100) DEFAULT NULL,
  `PHONE` varchar(100) DEFAULT NULL,
  `Ориентир` longtext,
  `Улица` longtext,
  `Общая площадь` longtext,
  `Объект находится в` longtext,
  `Рядом находится` longtext,
  `Цена` longtext,
  PRIMARY KEY (`OBJECT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `s_shoot_land_in_point` (
  `OBJECT_ID` varchar(32) NOT NULL,
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `OPERATION_ID` varchar(32) NOT NULL,
  `DATE_BEGIN` datetime NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `USER_NAME` varchar(100) DEFAULT NULL,
  `PHONE` varchar(100) DEFAULT NULL,
  `Ориентир` longtext,
  `Улица` longtext,
  `Участок` longtext,
  `Категория` longtext,
  `Назначение` longtext,
  `Рядом находится` longtext,
  `Цена` longtext,
  PRIMARY KEY (`OBJECT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `s_shoot_land_out_point` (
  `OBJECT_ID` varchar(32) NOT NULL,
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `OPERATION_ID` varchar(32) NOT NULL,
  `DATE_BEGIN` datetime NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `USER_NAME` varchar(100) DEFAULT NULL,
  `PHONE` varchar(100) DEFAULT NULL,
  `Территория` longtext,
  `Населенный пункт` longtext,
  `Удаленность` longtext,
  `Категория` longtext,
  `Назначение` longtext,
  `Участок` longtext,
  `Рядом находится` longtext,
  `Цена` longtext,
  PRIMARY KEY (`OBJECT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `s_shoot_new_buildings` (
  `OBJECT_ID` varchar(32) NOT NULL,
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `OPERATION_ID` varchar(32) NOT NULL,
  `DATE_BEGIN` datetime NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `USER_NAME` varchar(100) DEFAULT NULL,
  `PHONE` varchar(100) DEFAULT NULL,
  `Комн` longtext,
  `Район` longtext,
  `Ориентир` longtext,
  `Улица` longtext,
  `Пл, м2` longtext,
  `Тип` longtext,
  `Этаж` longtext,
  `Цена` longtext,
  PRIMARY KEY (`OBJECT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `s_shoot_offices` (
  `OBJECT_ID` varchar(32) NOT NULL,
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `OPERATION_ID` varchar(32) NOT NULL,
  `DATE_BEGIN` datetime NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `USER_NAME` varchar(100) DEFAULT NULL,
  `PHONE` varchar(100) DEFAULT NULL,
  `Комн` longtext,
  `Общая площадь` longtext,
  `Ориентир` longtext,
  `Улица` longtext,
  `Объект находится в` longtext,
  `Этаж` longtext,
  `Тел` longtext,
  `Интернет` longtext,
  `Цена` longtext,
  PRIMARY KEY (`OBJECT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `s_shoot_private_houses` (
  `OBJECT_ID` varchar(32) NOT NULL,
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `OPERATION_ID` varchar(32) NOT NULL,
  `DATE_BEGIN` datetime NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `USER_NAME` varchar(100) DEFAULT NULL,
  `PHONE` varchar(100) DEFAULT NULL,
  `Ориентир` longtext,
  `Улица` longtext,
  `Пл, м2` longtext,
  `Общая площадь` longtext,
  `Тип` longtext,
  `Этажность дома` longtext,
  `Участок` longtext,
  `Дополнительные строения` longtext,
  `Цена` longtext,
  PRIMARY KEY (`OBJECT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `s_shoot_productions` (
  `OBJECT_ID` varchar(32) NOT NULL,
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `OPERATION_ID` varchar(32) NOT NULL,
  `DATE_BEGIN` datetime NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `USER_NAME` varchar(100) DEFAULT NULL,
  `PHONE` varchar(100) DEFAULT NULL,
  `Населенный пункт` longtext,
  `Общая площадь` longtext,
  `Высота потолка` longtext,
  `Тип` longtext,
  `Рядом находится` longtext,
  `Цена` longtext,
  PRIMARY KEY (`OBJECT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `s_shoot_restaurants` (
  `OBJECT_ID` varchar(32) NOT NULL,
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `OPERATION_ID` varchar(32) NOT NULL,
  `DATE_BEGIN` datetime NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `USER_NAME` varchar(100) DEFAULT NULL,
  `PHONE` varchar(100) DEFAULT NULL,
  `Ориентир` longtext,
  `Улица` longtext,
  `Общая площадь` longtext,
  `Объект находится в` longtext,
  `Рядом находится` longtext,
  `Тип` longtext,
  `Высота потолка` longtext,
  `Цена` longtext,
  PRIMARY KEY (`OBJECT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `s_shoot_town_houses` (
  `OBJECT_ID` varchar(32) NOT NULL,
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `OPERATION_ID` varchar(32) NOT NULL,
  `DATE_BEGIN` datetime NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `USER_NAME` varchar(100) DEFAULT NULL,
  `PHONE` varchar(100) DEFAULT NULL,
  `Ориентир` longtext,
  `Улица` longtext,
  `Пл, м2` longtext,
  `Общая площадь` longtext,
  `Тип` longtext,
  `Этажность дома` longtext,
  `Участок` longtext,
  `Рядом находится` longtext,
  `Цена` longtext,
  PRIMARY KEY (`OBJECT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `s_shoot_trade_premises` (
  `OBJECT_ID` varchar(32) NOT NULL,
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `OPERATION_ID` varchar(32) NOT NULL,
  `DATE_BEGIN` datetime NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `USER_NAME` varchar(100) DEFAULT NULL,
  `PHONE` varchar(100) DEFAULT NULL,
  `Ориентир` longtext,
  `Улица` longtext,
  `Общая площадь` longtext,
  `Объект находится в` longtext,
  `Рядом находится` longtext,
  `Высота потолка` longtext,
  `Этажность дома` longtext,
  `Цена` longtext,
  PRIMARY KEY (`OBJECT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `sessions` (
  `SESSION_ID` varchar(32) NOT NULL,
  `ACCOUNT_ID` varchar(32) NOT NULL,
  `APPLICATION_ID` varchar(32) NOT NULL,
  `DATE_CREATE` datetime NOT NULL,
  `DATE_CHANGE` datetime NOT NULL,
  `PARAMS` longblob,
  PRIMARY KEY (`SESSION_ID`),
  KEY `ACCOUNT_ID` (`ACCOUNT_ID`),
  KEY `APPLICATION_ID` (`APPLICATION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `type_params` (
  `TYPE_ID` varchar(32) NOT NULL DEFAULT '',
  `PARAM_ID` varchar(32) NOT NULL DEFAULT '',
  `VISIBLE` int(11) NOT NULL,
  `MAIN` int(11) NOT NULL,
  `PRIORITY` int(11) NOT NULL,
  `OPERATION_ID` varchar(32) NOT NULL,
  PRIMARY KEY (`TYPE_ID`,`PARAM_ID`,`OPERATION_ID`),
  KEY `OPERATION_ID` (`OPERATION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `types` (
  `TYPE_ID` varchar(32) NOT NULL,
  `NAME` varchar(100) NOT NULL,
  `DESCRIPTION` varchar(250) DEFAULT NULL,
  `PRIORITY` int(11) NOT NULL,
  `VISIBLE` int(11) DEFAULT NULL,
  PRIMARY KEY (`TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `guid` varchar(32) DEFAULT NULL,
  `code` varchar(16) DEFAULT NULL COMMENT 'Код торговой программы',
  `login` varchar(10) DEFAULT NULL,
  `user_password` varchar(40) DEFAULT NULL,
  `sur_name` varchar(32) DEFAULT NULL COMMENT 'Фамилия',
  `first_name` varchar(32) DEFAULT NULL,
  `last_name` varchar(32) DEFAULT NULL,
  `job_title` varchar(32) DEFAULT NULL,
  `user_phone` varchar(32) DEFAULT NULL,
  `user_email` varchar(32) DEFAULT NULL,
  `user_city` varchar(150) DEFAULT NULL COMMENT 'Город',
  `user_adress` varchar(200) DEFAULT NULL,
  `user_descr` varchar(200) DEFAULT NULL,
  `user_skidka` varchar(32) DEFAULT NULL,
  `user_status` varchar(32) DEFAULT NULL,
  `send` int(2) DEFAULT NULL COMMENT 'Участие в рассылках (0 - нет, 1- да)',
  `status` int(1) DEFAULT NULL COMMENT 'Статус',
  PRIMARY KEY (`user_id`)
) ENGINE=MyISAM AUTO_INCREMENT=147 DEFAULT CHARSET=cp1251 COMMENT='Пользователи системы';

CREATE TABLE `view_types` (
  `VIEW_ID` varchar(32) NOT NULL,
  `TYPE_ID` varchar(32) NOT NULL,
  `PRIORITY` int(11) NOT NULL,
  PRIMARY KEY (`VIEW_ID`,`TYPE_ID`),
  KEY `TYPE_ID` (`TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `views` (
  `VIEW_ID` varchar(32) NOT NULL,
  `NAME` varchar(100) NOT NULL,
  `DESCRIPTION` varchar(250) DEFAULT NULL,
  `PRIORITY` int(11) NOT NULL,
  PRIMARY KEY (`VIEW_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE `vote` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL COMMENT 'id пользователя если есть',
  `type_id` int(11) DEFAULT NULL COMMENT '4- конкурс',
  `article_id` int(11) DEFAULT NULL COMMENT 'id заметки',
  `vote` int(5) DEFAULT NULL COMMENT 'Голосов',
  `date` date DEFAULT NULL,
  `time` time DEFAULT NULL,
  `ip` varchar(16) DEFAULT NULL COMMENT 'IP-адрес',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=31 DEFAULT CHARSET=cp1251 COMMENT='Голосования по статьям, новостям';

CREATE ALGORITHM=UNDEFINED DEFINER=`BIS`@`%` SQL SECURITY DEFINER VIEW `s_account_params` AS select `ap`.`ACCOUNT_ID` AS `ACCOUNT_ID`,`ap`.`PARAM_ID` AS `PARAM_ID`,`ap`.`PRIORITY` AS `PRIORITY`,`a`.`NAME` AS `ACCOUNT_NAME`,`a`.`DESCRIPTION` AS `ACCOUNT_DESCRIPTION`,`p`.`NAME` AS `PARAM_NAME` from ((`account_params` `AP` join `accounts` `A` on((`a`.`ACCOUNT_ID` = `ap`.`ACCOUNT_ID`))) join `params` `P` on((`p`.`PARAM_ID` = `ap`.`PARAM_ID`)));
CREATE ALGORITHM=UNDEFINED DEFINER=`BIS`@`%` SQL SECURITY DEFINER VIEW `s_account_presentations` AS select `ap`.`ACCOUNT_ID` AS `ACCOUNT_ID`,`ap`.`VIEW_ID` AS `VIEW_ID`,`ap`.`TYPE_ID` AS `TYPE_ID`,`ap`.`OPERATION_ID` AS `OPERATION_ID`,`ap`.`PRESENTATION_ID` AS `PRESENTATION_ID`,`ap`.`CONDITIONS` AS `CONDITIONS`,`a`.`USER_NAME` AS `USER_NAME`,`v`.`NAME` AS `VIEW_NAME`,`t`.`NAME` AS `TYPE_NAME`,`o`.`NAME` AS `OPERATION_NAME`,`p`.`NAME` AS `PRESENTATION_NAME` from (((((`account_presentations` `AP` join `accounts` `A` on((`a`.`ACCOUNT_ID` = `ap`.`ACCOUNT_ID`))) join `views` `V` on((`v`.`VIEW_ID` = `ap`.`VIEW_ID`))) join `types` `T` on((`t`.`TYPE_ID` = `ap`.`TYPE_ID`))) join `operations` `O` on((`o`.`OPERATION_ID` = `ap`.`OPERATION_ID`))) join `presentations` `P` on((`p`.`PRESENTATION_ID` = `ap`.`PRESENTATION_ID`)));
CREATE ALGORITHM=UNDEFINED DEFINER=`BIS`@`%` SQL SECURITY DEFINER VIEW `s_account_roles` AS select `ap`.`ROLE_ID` AS `ROLE_ID`,`ap`.`ACCOUNT_ID` AS `ACCOUNT_ID`,`r`.`USER_NAME` AS `ROLE_NAME`,`a`.`USER_NAME` AS `USER_NAME` from ((`account_roles` `AP` join `accounts` `R` on((`r`.`ACCOUNT_ID` = `ap`.`ROLE_ID`))) join `accounts` `A` on((`a`.`ACCOUNT_ID` = `ap`.`ACCOUNT_ID`)));
CREATE ALGORITHM=UNDEFINED DEFINER=`BIS`@`%` SQL SECURITY DEFINER VIEW `s_accounts` AS select `a`.`ACCOUNT_ID` AS `ACCOUNT_ID`,`a`.`PASSWORD` AS `PASSWORD`,`a`.`DESCRIPTION` AS `DESCRIPTION`,`a`.`DB_PASSWORD` AS `DB_PASSWORD`,`a`.`IS_ROLE` AS `IS_ROLE`,`a`.`USER_NAME` AS `USER_NAME`,`a`.`FIRM_ID` AS `FIRM_ID`,`a`.`LOCKED` AS `LOCKED`,`a`.`AUTO_CREATED` AS `AUTO_CREATED`,`a`.`SURNAME` AS `SURNAME`,`a`.`NAME` AS `NAME`,`a`.`PATRONYMIC` AS `PATRONYMIC`,`a`.`PHONE` AS `PHONE`,`a`.`EMAIL` AS `EMAIL`,`a`.`DB_USER_NAME` AS `DB_USER_NAME`,`f`.`SMALL_NAME` AS `FIRM_SMALL_NAME` from (`accounts` `A` left join `firms` `F` on((`f`.`FIRM_ID` = `a`.`FIRM_ID`)));
CREATE ALGORITHM=UNDEFINED DEFINER=`BIS`@`%` SQL SECURITY DEFINER VIEW `s_application_interfaces` AS select `ai`.`APPLICATION_ID` AS `APPLICATION_ID`,`ai`.`INTERFACE_ID` AS `INTERFACE_ID`,`ai`.`PRIORITY` AS `PRIORITY`,`ai`.`AUTO_RUN` AS `AUTO_RUN`,`a`.`NAME` AS `APPLICATION_NAME`,`i`.`NAME` AS `INTERFACE_NAME` from ((`application_interfaces` `AI` join `applications` `A` on((`a`.`APPLICATION_ID` = `ai`.`APPLICATION_ID`))) join `interfaces` `I` on((`i`.`INTERFACE_ID` = `ai`.`INTERFACE_ID`)));
CREATE ALGORITHM=UNDEFINED DEFINER=`BIS`@`%` SQL SECURITY DEFINER VIEW `s_applications` AS select `applications`.`APPLICATION_ID` AS `APPLICATION_ID`,`applications`.`NAME` AS `NAME`,`applications`.`DESCRIPTION` AS `DESCRIPTION`,`applications`.`LOCKED` AS `LOCKED` from `applications`;
CREATE ALGORITHM=UNDEFINED DEFINER=`BIS`@`%` SQL SECURITY DEFINER VIEW `s_column_params` AS select `cp`.`COLUMN_ID` AS `COLUMN_ID`,`cp`.`PARAM_ID` AS `PARAM_ID`,`cp`.`PRIORITY` AS `PRIORITY`,`cp`.`STRING_BEFORE` AS `STRING_BEFORE`,`cp`.`STRING_AFTER` AS `STRING_AFTER`,`c`.`NAME` AS `COLUMN_NAME`,`p`.`NAME` AS `PARAM_NAME` from ((`column_params` `CP` join `columns` `C` on((`c`.`COLUMN_ID` = `cp`.`COLUMN_ID`))) join `params` `P` on((`p`.`PARAM_ID` = `cp`.`PARAM_ID`)));
CREATE ALGORITHM=UNDEFINED DEFINER=`BIS`@`%` SQL SECURITY DEFINER VIEW `s_columns` AS select `columns`.`COLUMN_ID` AS `COLUMN_ID`,`columns`.`NAME` AS `NAME`,`columns`.`DESCRIPTION` AS `DESCRIPTION`,`columns`.`HTML_HEAD` AS `HTML_HEAD`,`columns`.`HTML_DATA` AS `HTML_DATA` from `columns`;
CREATE ALGORITHM=UNDEFINED DEFINER=`BIS`@`%` SQL SECURITY DEFINER VIEW `s_firm_types` AS select `firm_types`.`FIRM_TYPE_ID` AS `FIRM_TYPE_ID`,`firm_types`.`NAME` AS `NAME`,`firm_types`.`DESCRIPTION` AS `DESCRIPTION`,`firm_types`.`PRIORITY` AS `PRIORITY` from `firm_types`;
CREATE ALGORITHM=UNDEFINED DEFINER=`BIS`@`%` SQL SECURITY DEFINER VIEW `s_firms` AS select `f`.`FIRM_ID` AS `FIRM_ID`,`f`.`FIRM_TYPE_ID` AS `FIRM_TYPE_ID`,`f`.`PARENT_ID` AS `PARENT_ID`,`f`.`SMALL_NAME` AS `SMALL_NAME`,`f`.`FULL_NAME` AS `FULL_NAME`,`f`.`INN` AS `INN`,`f`.`PAYMENT_ACCOUNT` AS `PAYMENT_ACCOUNT`,`f`.`BANK` AS `BANK`,`f`.`BIK` AS `BIK`,`f`.`CORR_ACCOUNT` AS `CORR_ACCOUNT`,`f`.`LEGAL_ADDRESS` AS `LEGAL_ADDRESS`,`f`.`POST_ADDRESS` AS `POST_ADDRESS`,`f`.`PHONE` AS `PHONE`,`f`.`FAX` AS `FAX`,`f`.`EMAIL` AS `EMAIL`,`f`.`SITE` AS `SITE`,`f`.`OKONH` AS `OKONH`,`f`.`OKPO` AS `OKPO`,`f`.`KPP` AS `KPP`,`f`.`DIRECTOR` AS `DIRECTOR`,`f`.`ACCOUNTANT` AS `ACCOUNTANT`,`ft`.`NAME` AS `FIRM_TYPE_NAME`,`f1`.`SMALL_NAME` AS `PARENT_SMALL_NAME` from ((`firms` `F` join `firm_types` `FT` on((`ft`.`FIRM_TYPE_ID` = `f`.`FIRM_TYPE_ID`))) left join `firms` `F1` on((`f1`.`FIRM_ID` = `f`.`PARENT_ID`)));
CREATE ALGORITHM=UNDEFINED DEFINER=`BIS`@`%` SQL SECURITY DEFINER VIEW `s_interfaces` AS select `interfaces`.`INTERFACE_ID` AS `INTERFACE_ID`,`interfaces`.`NAME` AS `NAME`,`interfaces`.`DESCRIPTION` AS `DESCRIPTION`,`interfaces`.`INTERNAL` AS `INTERNAL`,`interfaces`.`INTERFACE_CLASS` AS `INTERFACE_CLASS`,`interfaces`.`MODULE_NAME` AS `MODULE_NAME`,`interfaces`.`MODULE_INTERFACE` AS `MODULE_INTERFACE` from `interfaces`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `s_object_params_ex` AS select `op`.`OBJECT_PARAM_ID` AS `OBJECT_PARAM_ID`,`op`.`ACCOUNT_ID` AS `ACCOUNT_ID`,`op`.`PARAM_ID` AS `PARAM_ID`,`op`.`OBJECT_ID` AS `OBJECT_ID`,`op`.`DATE_CREATE` AS `DATE_CREATE`,`op`.`VALUE` AS `VALUE`,`op`.`DESCRIPTION` AS `DESCRIPTION`,`a`.`USER_NAME` AS `USER_NAME`,`p`.`NAME` AS `PARAM_NAME`,`p`.`DESCRIPTION` AS `PARAM_DESCRIPTION`,`tp`.`PRIORITY` AS `PARAM_PRIORITY`,`tp`.`TYPE_ID` AS `TYPE_ID`,`tp`.`OPERATION_ID` AS `OPERATION_ID` from ((((`object_params` `OP` join `accounts` `A` on((`a`.`ACCOUNT_ID` = `op`.`ACCOUNT_ID`))) join `params` `P` on((`p`.`PARAM_ID` = `op`.`PARAM_ID`))) join `objects` `O` on((`o`.`OBJECT_ID` = `op`.`OBJECT_ID`))) join `type_params` `TP` on((`tp`.`PARAM_ID` = `p`.`PARAM_ID`)));
CREATE ALGORITHM=UNDEFINED DEFINER=`BIS`@`%` SQL SECURITY DEFINER VIEW `s_objects` AS select `o`.`OBJECT_ID` AS `OBJECT_ID`,`o`.`VIEW_ID` AS `VIEW_ID`,`o`.`TYPE_ID` AS `TYPE_ID`,`o`.`ACCOUNT_ID` AS `ACCOUNT_ID`,`o`.`DATE_BEGIN` AS `DATE_BEGIN`,`o`.`DATE_END` AS `DATE_END`,`o`.`STATUS` AS `STATUS`,`o`.`OPERATION_ID` AS `OPERATION_ID`,`a`.`USER_NAME` AS `USER_NAME`,`v`.`NAME` AS `VIEW_NAME`,`t`.`NAME` AS `TYPE_NAME`,`op`.`NAME` AS `OPERATION_NAME` from ((((`objects` `O` join `accounts` `A` on((`a`.`ACCOUNT_ID` = `o`.`ACCOUNT_ID`))) join `views` `V` on((`v`.`VIEW_ID` = `o`.`VIEW_ID`))) join `types` `T` on((`t`.`TYPE_ID` = `o`.`TYPE_ID`))) join `operations` `OP` on((`op`.`OPERATION_ID` = `o`.`OPERATION_ID`)));
CREATE ALGORITHM=UNDEFINED DEFINER=`BIS`@`%` SQL SECURITY DEFINER VIEW `s_operations` AS select `operations`.`OPERATION_ID` AS `OPERATION_ID`,`operations`.`NAME` AS `NAME`,`operations`.`DESCRIPTION` AS `DESCRIPTION`,`operations`.`PRIORITY` AS `PRIORITY` from `operations`;
CREATE ALGORITHM=UNDEFINED DEFINER=`BIS`@`%` SQL SECURITY DEFINER VIEW `s_param_value_depends` AS select `pvd`.`WHAT_PARAM_VALUE_ID` AS `WHAT_PARAM_VALUE_ID`,`pvd`.`FROM_PARAM_VALUE_ID` AS `FROM_PARAM_VALUE_ID`,`pv1`.`NAME` AS `WHAT_PARAM_VALUE_NAME`,`pv2`.`NAME` AS `FROM_PARAM_VALUE_NAME`,`pv1`.`PARAM_ID` AS `WHAT_PARAM_ID`,`pv1`.`PRIORITY` AS `WHAT_PRIORITY`,`pv2`.`PARAM_ID` AS `FROM_PARAM_ID`,`pv2`.`PRIORITY` AS `FROM_PRIORITY`,`p1`.`NAME` AS `WHAT_PARAM_NAME`,`p2`.`NAME` AS `FROM_PARAM_NAME` from ((((`param_value_depends` `PVD` join `param_values` `PV1` on((`pv1`.`PARAM_VALUE_ID` = `pvd`.`WHAT_PARAM_VALUE_ID`))) join `param_values` `PV2` on((`pv2`.`PARAM_VALUE_ID` = `pvd`.`FROM_PARAM_VALUE_ID`))) join `params` `P1` on((`p1`.`PARAM_ID` = `pv1`.`PARAM_ID`))) join `params` `P2` on((`p2`.`PARAM_ID` = `pv2`.`PARAM_ID`)));
CREATE ALGORITHM=UNDEFINED DEFINER=`BIS`@`%` SQL SECURITY DEFINER VIEW `s_param_value_variants` AS select `pvv`.`PARAM_VALUE_ID` AS `PARAM_VALUE_ID`,`pvv`.`VALUE` AS `VALUE`,`pvv`.`PRIORITY` AS `PRIORITY`,`pv`.`NAME` AS `PARAM_VALUE_NAME` from (`param_value_variants` `PVV` join `param_values` `PV` on((`pv`.`PARAM_VALUE_ID` = `pvv`.`PARAM_VALUE_ID`)));
CREATE ALGORITHM=UNDEFINED DEFINER=`BIS`@`%` SQL SECURITY DEFINER VIEW `s_param_values` AS select `pv`.`PARAM_VALUE_ID` AS `PARAM_VALUE_ID`,`pv`.`PARAM_ID` AS `PARAM_ID`,`pv`.`NAME` AS `NAME`,`pv`.`DESCRIPTION` AS `DESCRIPTION`,`pv`.`PRIORITY` AS `PRIORITY`,`p`.`NAME` AS `PARAM_NAME`,`p`.`ELEMENT_TYPE` AS `ELEMENT_TYPE` from (`param_values` `PV` join `params` `P` on((`p`.`PARAM_ID` = `pv`.`PARAM_ID`)));
CREATE ALGORITHM=UNDEFINED DEFINER=`BIS`@`%` SQL SECURITY DEFINER VIEW `s_params` AS select `params`.`PARAM_ID` AS `PARAM_ID`,`params`.`NAME` AS `NAME`,`params`.`DESCRIPTION` AS `DESCRIPTION`,`params`.`PARAM_TYPE` AS `PARAM_TYPE`,`params`.`IS_NULL` AS `IS_NULL`,`params`.`FORMAT` AS `FORMAT`,`params`.`OUTPUT_NAME` AS `OUTPUT_NAME` from `params`;
CREATE ALGORITHM=UNDEFINED DEFINER=`BIS`@`%` SQL SECURITY DEFINER VIEW `s_permissions` AS select `p`.`PERMISSION_ID` AS `PERMISSION_ID`,`p`.`ACCOUNT_ID` AS `ACCOUNT_ID`,`p`.`INTERFACE_ID` AS `INTERFACE_ID`,`p`.`RIGHT_ACCESS` AS `RIGHT_ACCESS`,`p`.`VALUE` AS `VALUE`,`a`.`USER_NAME` AS `USER_NAME`,`i`.`NAME` AS `INTERFACE_NAME` from ((`permissions` `P` join `accounts` `A` on((`a`.`ACCOUNT_ID` = `p`.`ACCOUNT_ID`))) join `interfaces` `I` on((`i`.`INTERFACE_ID` = `p`.`INTERFACE_ID`)));
CREATE ALGORITHM=UNDEFINED DEFINER=`BIS`@`%` SQL SECURITY DEFINER VIEW `s_presentation_columns` AS select `pc`.`PRESENTATION_ID` AS `PRESENTATION_ID`,`pc`.`COLUMN_ID` AS `COLUMN_ID`,`pc`.`PRIORITY` AS `PRIORITY`,`pc`.`COLUMN_GROUP` AS `COLUMN_GROUP`,`pc`.`STRING_BEFORE` AS `STRING_BEFORE`,`pc`.`STRING_AFTER` AS `STRING_AFTER`,`p`.`NAME` AS `PRESENTATION_NAME`,`c`.`NAME` AS `COLUMN_NAME` from ((`presentation_columns` `PC` join `presentations` `P` on((`p`.`PRESENTATION_ID` = `pc`.`PRESENTATION_ID`))) join `columns` `C` on((`c`.`COLUMN_ID` = `pc`.`COLUMN_ID`)));
CREATE ALGORITHM=UNDEFINED DEFINER=`BIS`@`%` SQL SECURITY DEFINER VIEW `s_presentations` AS select `presentations`.`PRESENTATION_ID` AS `PRESENTATION_ID`,`presentations`.`NAME` AS `NAME`,`presentations`.`DESCRIPTION` AS `DESCRIPTION`,`presentations`.`TABLE_NAME` AS `TABLE_NAME`,`presentations`.`SORTING` AS `SORTING` from `presentations`;
CREATE ALGORITHM=UNDEFINED DEFINER=`BIS`@`%` SQL SECURITY DEFINER VIEW `s_profiles` AS select `p`.`ACCOUNT_ID` AS `ACCOUNT_ID`,`p`.`APPLICATION_ID` AS `APPLICATION_ID`,`p`.`PROFILE` AS `PROFILE`,`ac`.`USER_NAME` AS `USER_NAME`,`ap`.`NAME` AS `APPLICATION_NAME` from ((`profiles` `P` join `accounts` `AC` on((`ac`.`ACCOUNT_ID` = `p`.`ACCOUNT_ID`))) join `applications` `AP` on((`ap`.`APPLICATION_ID` = `p`.`APPLICATION_ID`)));
CREATE ALGORITHM=UNDEFINED DEFINER=`BIS`@`%` SQL SECURITY DEFINER VIEW `s_sessions` AS select `s`.`SESSION_ID` AS `SESSION_ID`,`s`.`ACCOUNT_ID` AS `ACCOUNT_ID`,`s`.`APPLICATION_ID` AS `APPLICATION_ID`,`s`.`DATE_CREATE` AS `DATE_CREATE`,`s`.`DATE_CHANGE` AS `DATE_CHANGE`,`s`.`PARAMS` AS `PARAMS`,`ac`.`USER_NAME` AS `USER_NAME`,`ap`.`NAME` AS `APPLICATION_NAME` from ((`sessions` `S` join `accounts` `AC` on((`ac`.`ACCOUNT_ID` = `s`.`ACCOUNT_ID`))) join `applications` `AP` on((`ap`.`APPLICATION_ID` = `s`.`APPLICATION_ID`)));
CREATE ALGORITHM=UNDEFINED DEFINER=`BIS`@`%` SQL SECURITY DEFINER VIEW `s_type_params` AS select `tp`.`TYPE_ID` AS `TYPE_ID`,`tp`.`PARAM_ID` AS `PARAM_ID`,`tp`.`VISIBLE` AS `VISIBLE`,`tp`.`MAIN` AS `MAIN`,`tp`.`PRIORITY` AS `PRIORITY`,`tp`.`OPERATION_ID` AS `OPERATION_ID`,`t`.`NAME` AS `TYPE_NAME`,`p`.`NAME` AS `PARAM_NAME`,`o`.`NAME` AS `OPERATION_NAME`,`p`.`PARAM_TYPE` AS `PARAM_TYPE` from (((`type_params` `TP` join `types` `T` on((`t`.`TYPE_ID` = `tp`.`TYPE_ID`))) join `params` `P` on((`p`.`PARAM_ID` = `tp`.`PARAM_ID`))) join `operations` `O` on((`o`.`OPERATION_ID` = `tp`.`OPERATION_ID`)));
CREATE ALGORITHM=UNDEFINED DEFINER=`BIS`@`%` SQL SECURITY DEFINER VIEW `s_types` AS select `types`.`TYPE_ID` AS `TYPE_ID`,`types`.`NAME` AS `NAME`,`types`.`DESCRIPTION` AS `DESCRIPTION`,`types`.`PRIORITY` AS `PRIORITY` from `types`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `s_view_types` AS select `vt`.`VIEW_ID` AS `VIEW_ID`,`vt`.`TYPE_ID` AS `TYPE_ID`,`vt`.`PRIORITY` AS `PRIORITY`,`v`.`NAME` AS `VIEW_NAME`,`v`.`DESCRIPTION` AS `VIEW_DESCRIPTION`,`t`.`NAME` AS `TYPE_NAME` from ((`view_types` `VT` join `views` `V` on((`v`.`VIEW_ID` = `vt`.`VIEW_ID`))) join `types` `T` on((`t`.`TYPE_ID` = `vt`.`TYPE_ID`)));
CREATE ALGORITHM=UNDEFINED DEFINER=`BIS`@`%` SQL SECURITY DEFINER VIEW `s_views` AS select `views`.`VIEW_ID` AS `VIEW_ID`,`views`.`NAME` AS `NAME`,`views`.`DESCRIPTION` AS `DESCRIPTION`,`views`.`PRIORITY` AS `PRIORITY` from `views`;

CREATE DEFINER=`BIS`@`%` PROCEDURE `D_ACCOUNT`(
  IN OLD_ACCOUNT_ID VARCHAR(32)
)
BEGIN
  DELETE FROM ACCOUNTS
        WHERE ACCOUNT_ID=OLD_ACCOUNT_ID;
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `D_ACCOUNT_PARAM`(
  IN OLD_ACCOUNT_ID VARCHAR(32),
	IN OLD_PARAM_ID VARCHAR(32)
)
BEGIN
  DELETE FROM /*PREFIX*/ACCOUNT_PARAMS 
        WHERE ACCOUNT_ID=OLD_ACCOUNT_ID
				  AND PARAM_ID=OLD_PARAM_ID;
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `D_ACCOUNT_PRESENTATION`(
  IN OLD_ACCOUNT_ID VARCHAR(32),
	IN OLD_VIEW_ID VARCHAR(32),
	IN OLD_TYPE_ID VARCHAR(32),
	IN OLD_OPERATION_ID VARCHAR(32)
)
BEGIN
  DELETE FROM /*PREFIX*/ACCOUNT_PRESENTATIONS 
        WHERE ACCOUNT_ID=OLD_ACCOUNT_ID
				  AND VIEW_ID=OLD_VIEW_ID
				  AND TYPE_ID=OLD_TYPE_ID
				  AND OPERATION_ID=OLD_OPERATION_ID;
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `D_ACCOUNT_ROLE`(
  IN OLD_ROLE_ID VARCHAR(32),
	IN OLD_ACCOUNT_ID VARCHAR(32)
)
BEGIN
  DELETE FROM /*PREFIX*/ACCOUNT_ROLES 
        WHERE ROLE_ID=OLD_ROLE_ID
				  AND ACCOUNT_ID=OLD_ACCOUNT_ID;
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `D_APPLICATION`(
  IN OLD_APPLICATION_ID VARCHAR(32)
)
BEGIN
  DELETE FROM /*PREFIX*/APPLICATIONS 
        WHERE APPLICATION_ID=OLD_APPLICATION_ID;
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `D_APPLICATION_INTERFACE`(
  IN OLD_APPLICATION_ID VARCHAR(32),
	IN OLD_INTERFACE_ID VARCHAR(32)
)
BEGIN
  DELETE FROM /*PREFIX*/APPLICATION_INTERFACES 
        WHERE APPLICATION_ID=OLD_APPLICATION_ID
				  AND INTERFACE_ID=OLD_INTERFACE_ID;
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `D_COLUMN`(
  IN OLD_COLUMN_ID VARCHAR(32)
)
BEGIN
  DELETE FROM /*PREFIX*/COLUMNS 
        WHERE COLUMN_ID=OLD_COLUMN_ID;
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `D_COLUMN_PARAM`(
  IN OLD_COLUMN_ID VARCHAR(32),
	IN OLD_PARAM_ID VARCHAR(32)
)
BEGIN
  DELETE FROM /*PREFIX*/COLUMN_PARAMS 
        WHERE COLUMN_ID=OLD_COLUMN_ID
				  AND PARAM_ID=OLD_PARAM_ID;
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `D_FIRM`(
  IN OLD_FIRM_ID VARCHAR(32)
)
BEGIN
  DELETE FROM /*PREFIX*/FIRMS
        WHERE FIRM_ID=OLD_FIRM_ID;
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `D_FIRM_TYPE`(
  IN OLD_FIRM_TYPE_ID VARCHAR(32)
)
BEGIN
  DELETE FROM /*PREFIX*/FIRM_TYPES 
        WHERE FIRM_TYPE_ID=OLD_FIRM_TYPE_ID;
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `D_INTERFACE`(
  IN OLD_INTERFACE_ID VARCHAR(32)
)
BEGIN
  DELETE FROM /*PREFIX*/INTERFACES 
        WHERE INTERFACE_ID=OLD_INTERFACE_ID;
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `D_OBJECT`(
  IN OLD_OBJECT_ID VARCHAR(32)
)
BEGIN
  DELETE FROM /*PREFIX*/OBJECTS
        WHERE OBJECT_ID=OLD_OBJECT_ID;
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `D_OBJECT_PARAM`(
  IN OLD_OBJECT_PARAM_ID VARCHAR(32)
)
BEGIN
  DELETE FROM /*PREFIX*/OBJECT_PARAMS 
        WHERE OBJECT_PARAM_ID=OLD_OBJECT_PARAM_ID;
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `D_OPERATION`(
  IN OLD_OPERATION_ID VARCHAR(32)
)
BEGIN
  DELETE FROM /*PREFIX*/OPERATIONS 
        WHERE OPERATION_ID=OLD_OPERATION_ID;
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `D_PARAM`(
  IN OLD_PARAM_ID VARCHAR(32)
)
BEGIN
  DELETE FROM /*PREFIX*/PARAMS 
        WHERE PARAM_ID=OLD_PARAM_ID;
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `D_PARAM_VALUE`(
  IN OLD_PARAM_VALUE_ID VARCHAR(32)
)
BEGIN
  DELETE FROM /*PREFIX*/PARAM_VALUES 
        WHERE PARAM_VALUE_ID=OLD_PARAM_VALUE_ID;
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `D_PARAM_VALUE_DEPEND`(
  IN OLD_WHAT_PARAM_VALUE_ID VARCHAR(32),
  IN OLD_FROM_PARAM_VALUE_ID VARCHAR(32)
)
BEGIN
  DELETE FROM /*PREFIX*/PARAM_VALUE_DEPENDS 
        WHERE WHAT_PARAM_VALUE_ID=OLD_WHAT_PARAM_VALUE_ID
				  AND FROM_PARAM_VALUE_ID=OLD_FROM_PARAM_VALUE_ID;
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `D_PARAM_VALUE_VARIANT`(
  IN OLD_PARAM_VALUE_ID VARCHAR(32),
	IN OLD_VALUE VARCHAR(100)
)
BEGIN
  DELETE FROM /*PREFIX*/PARAM_VALUE_VARIANTS 
        WHERE PARAM_VALUE_ID=OLD_PARAM_VALUE_ID
				  AND VALUE=OLD_VALUE;
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `D_PERMISSION`(
  IN OLD_PERMISSION_ID VARCHAR(32)
)
BEGIN
  DELETE FROM /*PREFIX*/PERMISSIONS
        WHERE PERMISSION_ID=OLD_PERMISSION_ID;
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `D_PRESENTATION`(
  IN OLD_PRESENTATION_ID VARCHAR(32)
)
BEGIN
  DELETE FROM /*PREFIX*/PRESENTATIONS 
        WHERE PRESENTATION_ID=OLD_PRESENTATION_ID;
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `D_PRESENTATION_COLUMN`(
  IN OLD_PRESENTATION_ID VARCHAR(32),
	IN OLD_COLUMN_ID VARCHAR(32)
)
BEGIN
  DELETE FROM /*PREFIX*/PRESENTATION_COLUMNS 
        WHERE PRESENTATION_ID=OLD_PRESENTATION_ID
				  AND COLUMN_ID=OLD_COLUMN_ID;
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `D_PROFILE`(
  IN OLD_ACCOUNT_ID VARCHAR(32),
	IN OLD_APPLICATION_ID VARCHAR(32)
)
BEGIN
  DELETE FROM /*PREFIX*/PROFILES 
        WHERE ACCOUNT_ID=OLD_ACCOUNT_ID
				  AND APPLICATION_ID=OLD_APPLICATION_ID;
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `D_SESSION`(
  IN OLD_SESSION_ID VARCHAR(32)
)
BEGIN
  DELETE FROM /*PREFIX*/SESSIONS
        WHERE SESSION_ID=OLD_SESSION_ID;
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `D_TYPE`(
  IN OLD_TYPE_ID VARCHAR(32)
)
BEGIN
  DELETE FROM /*PREFIX*/TYPES 
        WHERE TYPE_ID=OLD_TYPE_ID;
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `D_TYPE_PARAM`(
  IN OLD_TYPE_ID VARCHAR(32),
	IN OLD_PARAM_ID VARCHAR(32),
	IN OLD_OPERATION_ID VARCHAR(32)
)
BEGIN
  DELETE FROM /*PREFIX*/TYPE_PARAMS 
        WHERE TYPE_ID=OLD_TYPE_ID
				  AND PARAM_ID=OLD_PARAM_ID
					AND OPERATION_ID=OLD_OPERATION_ID;
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `D_VIEW`(
  IN OLD_VIEW_ID VARCHAR(32)
)
BEGIN
  DELETE FROM /*PREFIX*/VIEWS 
        WHERE VIEW_ID=OLD_VIEW_ID;
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `D_VIEW_TYPE`(
  IN OLD_VIEW_ID VARCHAR(32),
	IN OLD_TYPE_ID VARCHAR(32)
)
BEGIN
  DELETE FROM /*PREFIX*/VIEW_TYPES 
        WHERE VIEW_ID=OLD_VIEW_ID
				  AND TYPE_ID=OLD_TYPE_ID;
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `I_ACCOUNT`(
  IN ACCOUNT_ID VARCHAR(32),
  IN FIRM_ID VARCHAR(32),
  IN USER_NAME VARCHAR(100),
  IN PASSWORD VARCHAR(100),
  IN DESCRIPTION VARCHAR(250),
  IN DB_USER_NAME VARCHAR(100),
  IN DB_PASSWORD VARCHAR(100),
  IN IS_ROLE INTEGER,
  IN LOCKED INTEGER,  
  IN AUTO_CREATED INTEGER,
  IN SURNAME VARCHAR(100),
  IN NAME VARCHAR(100),
  IN PATRONYMIC VARCHAR(100),
  IN PHONE VARCHAR(100),
  IN EMAIL VARCHAR(100)
)
BEGIN
  INSERT INTO /*PREFIX*/ACCOUNTS (ACCOUNT_ID,FIRM_ID,USER_NAME,PASSWORD,DESCRIPTION,DB_USER_NAME,DB_PASSWORD,
	                                IS_ROLE,LOCKED,AUTO_CREATED,SURNAME,NAME,PATRONYMIC,PHONE,EMAIL)
       VALUES (ACCOUNT_ID,FIRM_ID,USER_NAME,PASSWORD,DESCRIPTION,DB_USER_NAME,DB_PASSWORD,
	             IS_ROLE,LOCKED,AUTO_CREATED,SURNAME,NAME,PATRONYMIC,PHONE,EMAIL);
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `I_ACCOUNT_PARAM`(
  IN ACCOUNT_ID VARCHAR(32),
  IN PARAM_ID VARCHAR(32),
  IN PRIORITY INTEGER
)
BEGIN
  INSERT INTO /*PREFIX*/ACCOUNT_PARAMS (ACCOUNT_ID,PARAM_ID,PRIORITY)
       VALUES (ACCOUNT_ID,PARAM_ID,PRIORITY);
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `I_ACCOUNT_PRESENTATION`(
  IN ACCOUNT_ID VARCHAR(32),
  IN VIEW_ID VARCHAR(32),
  IN TYPE_ID VARCHAR(32),
  IN OPERATION_ID VARCHAR(32),
  IN PRESENTATION_ID VARCHAR(32),
  IN CONDITIONS VARCHAR(250)
)
BEGIN
  INSERT INTO /*PREFIX*/ACCOUNT_PRESENTATIONS (ACCOUNT_ID,VIEW_ID,TYPE_ID,OPERATION_ID,PRESENTATION_ID,CONDITIONS)
       VALUES (ACCOUNT_ID,VIEW_ID,TYPE_ID,OPERATION_ID,PRESENTATION_ID,CONDITIONS);
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `I_ACCOUNT_ROLE`(
  IN ROLE_ID VARCHAR(32),
  IN ACCOUNT_ID VARCHAR(32)
)
BEGIN
  INSERT INTO /*PREFIX*/ACCOUNT_ROLES (ROLE_ID,ACCOUNT_ID)
       VALUES (ROLE_ID,ACCOUNT_ID);
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `I_APPLICATION`(
  IN APPLICATION_ID VARCHAR(32),
  IN NAME VARCHAR(100),
  IN DESCRIPTION VARCHAR(250),
  IN LOCKED INTEGER
)
BEGIN
  INSERT INTO /*PREFIX*/APPLICATIONS (APPLICATION_ID,NAME,DESCRIPTION,LOCKED)
       VALUES (APPLICATION_ID,NAME,DESCRIPTION,LOCKED);
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `I_APPLICATION_INTERFACE`(
  IN APPLICATION_ID VARCHAR(32),
  IN INTERFACE_ID VARCHAR(32),
  IN PRIORITY INTEGER,
	IN AUTO_RUN INTEGER
)
BEGIN
  INSERT INTO /*PREFIX*/APPLICATION_INTERFACES (APPLICATION_ID,INTERFACE_ID,PRIORITY,AUTO_RUN)
       VALUES (APPLICATION_ID,INTERFACE_ID,PRIORITY,AUTO_RUN);
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `I_COLUMN`(
  IN COLUMN_ID VARCHAR(32),
  IN NAME VARCHAR(100),
  IN DESCRIPTION VARCHAR(250),
	IN HTML_HEAD VARCHAR(100),
	IN HTML_DATA VARCHAR(100)
)
BEGIN
  INSERT INTO /*PREFIX*/COLUMNS (COLUMN_ID,NAME,DESCRIPTION,HTML_HEAD,HTML_DATA)
       VALUES (COLUMN_ID,NAME,DESCRIPTION,HTML_HEAD,HTML_DATA);
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `I_COLUMN_PARAM`(
  IN COLUMN_ID VARCHAR(32),
  IN PARAM_ID VARCHAR(32),
  IN PRIORITY INTEGER,
	IN STRING_BEFORE VARCHAR(100),
	IN STRING_AFTER VARCHAR(100)
)
BEGIN
  INSERT INTO /*PREFIX*/COLUMN_PARAMS (COLUMN_ID,PARAM_ID,PRIORITY,STRING_BEFORE,STRING_AFTER)
       VALUES (COLUMN_ID,PARAM_ID,PRIORITY,STRING_BEFORE,STRING_AFTER);
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `I_FIRM`(
  IN FIRM_ID VARCHAR(32),
  IN FIRM_TYPE_ID VARCHAR(32),
  IN PARENT_ID VARCHAR(32),
  IN SMALL_NAME VARCHAR(250),
  IN FULL_NAME VARCHAR(250),
  IN INN VARCHAR(12),
  IN PAYMENT_ACCOUNT VARCHAR(20),
  IN BANK VARCHAR(250),
  IN BIK VARCHAR(20),
  IN CORR_ACCOUNT VARCHAR(20),
  IN LEGAL_ADDRESS VARCHAR(250),
  IN POST_ADDRESS VARCHAR(250),
  IN PHONE VARCHAR(250),
  IN FAX VARCHAR(250),
  IN EMAIL VARCHAR(100),
  IN SITE VARCHAR(100),
  IN OKONH VARCHAR(20),
  IN OKPO VARCHAR(20),
  IN KPP VARCHAR(20),
  IN DIRECTOR VARCHAR(250),
  IN ACCOUNTANT VARCHAR(250)
)
BEGIN
  INSERT INTO /*PREFIX*/FIRMS (FIRM_ID,FIRM_TYPE_ID,PARENT_ID,SMALL_NAME,FULL_NAME,INN,PAYMENT_ACCOUNT,
	                             BANK,BIK,CORR_ACCOUNT,LEGAL_ADDRESS,POST_ADDRESS,PHONE,FAX,EMAIL,SITE,
															 OKONH,OKPO,KPP,DIRECTOR,ACCOUNTANT)
       VALUES (FIRM_ID,FIRM_TYPE_ID,PARENT_ID,SMALL_NAME,FULL_NAME,INN,PAYMENT_ACCOUNT,
               BANK,BIK,CORR_ACCOUNT,LEGAL_ADDRESS,POST_ADDRESS,PHONE,FAX,EMAIL,SITE,
  						 OKONH,OKPO,KPP,DIRECTOR,ACCOUNTANT);
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `I_FIRM_TYPE`(
  IN FIRM_TYPE_ID VARCHAR(32),
  IN NAME VARCHAR(100),
  IN DESCRIPTION VARCHAR(250),
	IN PRIORITY INTEGER
)
BEGIN
  INSERT INTO /*PREFIX*/FIRM_TYPES (FIRM_TYPE_ID,NAME,DESCRIPTION,PRIORITY)
       VALUES (FIRM_TYPE_ID,NAME,DESCRIPTION,PRIORITY);
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `I_INTERFACE`(
  IN INTERFACE_ID VARCHAR(32),
  IN NAME VARCHAR(100),
  IN DESCRIPTION VARCHAR(250),
  IN INTERNAL INTEGER, 
  IN INTERFACE_CLASS VARCHAR(100),
	IN MODULE_NAME VARCHAR(100),
	IN MODULE_INTERFACE VARCHAR(250)
)
BEGIN
  INSERT INTO /*PREFIX*/INTERFACES (INTERFACE_ID,NAME,DESCRIPTION,INTERNAL,INTERFACE_CLASS,MODULE_NAME,MODULE_INTERFACE)
       VALUES (INTERFACE_ID,NAME,DESCRIPTION,INTERNAL,INTERFACE_CLASS,MODULE_NAME,MODULE_INTERFACE);
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `I_OBJECT`(
  IN OBJECT_ID VARCHAR(32),
  IN ACCOUNT_ID VARCHAR(32),
  IN VIEW_ID VARCHAR(32),
  IN TYPE_ID VARCHAR(32),
	IN OPERATION_ID VARCHAR(32),
	IN DATE_BEGIN DATETIME,
	IN DATE_END DATETIME,
	IN STATUS INTEGER
)
BEGIN
  INSERT INTO /*PREFIX*/OBJECTS (OBJECT_ID,ACCOUNT_ID,VIEW_ID,TYPE_ID,OPERATION_ID,DATE_BEGIN,DATE_END,STATUS)
       VALUES (OBJECT_ID,ACCOUNT_ID,VIEW_ID,TYPE_ID,OPERATION_ID,DATE_BEGIN,DATE_END,STATUS);
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `I_OBJECT_PARAM`(
  IN OBJECT_PARAM_ID VARCHAR(32),
  IN ACCOUNT_ID VARCHAR(32),
  IN PARAM_ID VARCHAR(32),
  IN OBJECT_ID VARCHAR(32),
  IN DATE_CREATE DATETIME,
  IN VALUE LONGBLOB,
	IN DESCRIPTION VARCHAR(250)
)
BEGIN
  INSERT INTO /*PREFIX*/OBJECT_PARAMS (OBJECT_PARAM_ID,ACCOUNT_ID,PARAM_ID,OBJECT_ID,DATE_CREATE,VALUE,DESCRIPTION)
       VALUES (OBJECT_PARAM_ID,ACCOUNT_ID,PARAM_ID,OBJECT_ID,DATE_CREATE,VALUE,DESCRIPTION);
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `I_OPERATION`(
  IN OPERATION_ID VARCHAR(32),
  IN NAME VARCHAR(100),
  IN DESCRIPTION VARCHAR(250),
	IN PRIORITY INTEGER
)
BEGIN
  INSERT INTO /*PREFIX*/OPERATIONS (OPERATION_ID,NAME,DESCRIPTION,PRIORITY)
       VALUES (OPERATION_ID,NAME,DESCRIPTION,PRIORITY);
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `I_PARAM`(
  IN PARAM_ID VARCHAR(32),
  IN NAME VARCHAR(100),
  IN DESCRIPTION VARCHAR(250),
	IN PARAM_TYPE INTEGER,
	IN IS_NULL INTEGER,
	IN FORMAT VARCHAR(100)
)
BEGIN
  INSERT INTO /*PREFIX*/PARAMS (PARAM_ID,NAME,DESCRIPTION,PARAM_TYPE,IS_NULL,FORMAT)
       VALUES (PARAM_ID,NAME,DESCRIPTION,PARAM_TYPE,IS_NULL,FORMAT);
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `I_PARAM_VALUE`(
  IN PARAM_VALUE_ID VARCHAR(32),
  IN PARAM_ID VARCHAR(32),
  IN NAME VARCHAR(100),
  IN DESCRIPTION VARCHAR(250),
	IN PRIORITY INTEGER
)
BEGIN
  INSERT INTO /*PREFIX*/PARAM_VALUES (PARAM_VALUE_ID,PARAM_ID,NAME,DESCRIPTION,PRIORITY)
       VALUES (PARAM_VALUE_ID,PARAM_ID,NAME,DESCRIPTION,PRIORITY);
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `I_PARAM_VALUE_DEPEND`(
  IN WHAT_PARAM_VALUE_ID VARCHAR(32),
  IN FROM_PARAM_VALUE_ID VARCHAR(32)
)
BEGIN
  INSERT INTO /*PREFIX*/PARAM_VALUE_DEPENDS (WHAT_PARAM_VALUE_ID,FROM_PARAM_VALUE_ID)
       VALUES (WHAT_PARAM_VALUE_ID,FROM_PARAM_VALUE_ID);
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `I_PARAM_VALUE_VARIANT`(
  IN PARAM_VALUE_ID VARCHAR(32),
  IN VALUE VARCHAR(100),
  IN PRIORITY INTEGER
)
BEGIN
  INSERT INTO /*PREFIX*/PARAM_VALUE_VARIANTS (PARAM_VALUE_ID,VALUE,PRIORITY)
       VALUES (PARAM_VALUE_ID,VALUE,PRIORITY);
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `I_PERMISSION`(
  IN PERMISSION_ID VARCHAR(32),
  IN ACCOUNT_ID VARCHAR(32),
	IN INTERFACE_ID VARCHAR(32),
  IN RIGHT_ACCESS VARCHAR(250),
	IN VALUE VARCHAR(250)
)
BEGIN
  INSERT INTO /*PREFIX*/PERMISSIONS (PERMISSION_ID,ACCOUNT_ID,INTERFACE_ID,RIGHT_ACCESS,VALUE)
       VALUES (PERMISSION_ID,ACCOUNT_ID,INTERFACE_ID,RIGHT_ACCESS,VALUE);
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `I_PRESENTATION`(
  IN PRESENTATION_ID VARCHAR(32),
  IN NAME VARCHAR(100),
  IN DESCRIPTION VARCHAR(250),
  IN TABLE_NAME VARCHAR(100),
	IN SORTING VARCHAR(250)
)
BEGIN
  INSERT INTO /*PREFIX*/PRESENTATIONS (PRESENTATION_ID,NAME,DESCRIPTION,TABLE_NAME,SORTING)
       VALUES (PRESENTATION_ID,NAME,DESCRIPTION,TABLE_NAME,SORTING);
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `I_PRESENTATION_COLUMN`(
  IN PRESENTATION_ID VARCHAR(32),
  IN COLUMN_ID VARCHAR(32),
  IN PRIORITY INTEGER,
	IN COLUMN_GROUP INTEGER,
	IN STRING_BEFORE VARCHAR(100),
	IN STRING_AFTER VARCHAR(100)
)
BEGIN
  INSERT INTO /*PREFIX*/PRESENTATION_COLUMNS (PRESENTATION_ID,COLUMN_ID,PRIORITY,COLUMN_GROUP,STRING_BEFORE,STRING_AFTER)
       VALUES (PRESENTATION_ID,COLUMN_ID,PRIORITY,COLUMN_GROUP,STRING_BEFORE,STRING_AFTER);
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `I_PROFILE`(
  IN ACCOUNT_ID VARCHAR(32),
  IN APPLICATION_ID VARCHAR(32),
  IN PROFILE LONGBLOB
)
BEGIN
  INSERT INTO /*PREFIX*/PROFILES (ACCOUNT_ID,APPLICATION_ID,PROFILE)
       VALUES (ACCOUNT_ID,APPLICATION_ID,PROFILE);
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `I_SESSION`(
  IN SESSION_ID VARCHAR(32),
  IN ACCOUNT_ID VARCHAR(32),
	IN APPLICATION_ID VARCHAR(32),
  IN DATE_CREATE DATETIME,
	IN DATE_CHANGE DATETIME,
	IN PARAMS LONGBLOB
)
BEGIN
  INSERT INTO /*PREFIX*/SESSIONS (SESSION_ID,ACCOUNT_ID,APPLICATION_ID,DATE_CREATE,DATE_CHANGE,PARAMS)
       VALUES (SESSION_ID,ACCOUNT_ID,APPLICATION_ID,DATE_CREATE,DATE_CHANGE,PARAMS);
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `I_TYPE`(
  IN TYPE_ID VARCHAR(32),
  IN NAME VARCHAR(100),
  IN DESCRIPTION VARCHAR(250),
  IN PRIORITY INTEGER,
	IN VISIBLE INTEGER
)
BEGIN
  INSERT INTO /*PREFIX*/TYPES (TYPE_ID,NAME,DESCRIPTION,PRIORITY,VISIBLE)
       VALUES (TYPE_ID,NAME,DESCRIPTION,PRIORITY,VISIBLE);
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `I_TYPE_PARAM`(
  IN TYPE_ID VARCHAR(32),
  IN PARAM_ID VARCHAR(32),
	IN OPERATION_ID VARCHAR(32),
	IN VISIBLE INTEGER,
	IN MAIN INTEGER,
  IN PRIORITY INTEGER
)
BEGIN
  INSERT INTO /*PREFIX*/TYPE_PARAMS (TYPE_ID,PARAM_ID,OPERATION_ID,VISIBLE,MAIN,PRIORITY)
       VALUES (TYPE_ID,PARAM_ID,OPERATION_ID,VISIBLE,MAIN,PRIORITY);
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `I_VIEW`(
  IN VIEW_ID VARCHAR(32),
  IN NAME VARCHAR(100),
  IN DESCRIPTION VARCHAR(250),
	IN PRIORITY INTEGER
)
BEGIN
  INSERT INTO /*PREFIX*/VIEWS (VIEW_ID,NAME,DESCRIPTION,PRIORITY)
       VALUES (VIEW_ID,NAME,DESCRIPTION,PRIORITY);
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `I_VIEW_TYPE`(
  IN VIEW_ID VARCHAR(32),
  IN TYPE_ID VARCHAR(32),
  IN PRIORITY INTEGER
)
BEGIN
  INSERT INTO /*PREFIX*/VIEW_TYPES (VIEW_ID,TYPE_ID,PRIORITY)
       VALUES (VIEW_ID,TYPE_ID,PRIORITY);
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `R_PRESENTATION`(
  IN PRESENTATION_ID VARCHAR(32)
)
BEGIN
  DECLARE ATABLE VARCHAR(100);
     DECLARE COLUMN_ID VARCHAR(32);
     DECLARE VIEW_ID VARCHAR(32);
     DECLARE TYPE_ID VARCHAR(32);
     DECLARE OPERATION_ID VARCHAR(32);
     DECLARE PARAM_IDS VARCHAR(1000);
     DECLARE COLUMN_NAME VARCHAR(100);
     DECLARE OLD_COLUMN_ID VARCHAR(32);
     DECLARE PARAM_ID VARCHAR(32);
     DECLARE PARAM_TYPE INTEGER;
     DECLARE PARAM_COUNT INTEGER;
     DECLARE REAL_COUNT INTEGER;
     DECLARE STRING_BEFORE VARCHAR(100);
     DECLARE STRING_AFTER VARCHAR(100);
     DECLARE FIELD_NAME VARCHAR(1000);
     DECLARE NEW_QUERY VARCHAR(2000);
     DECLARE DONE INTEGER DEFAULT 0;
     DECLARE C1 CURSOR FOR SELECT PC.COLUMN_ID, C.NAME, CP.PARAM_ID, P.PARAM_TYPE,
                                  CP.STRING_BEFORE, CP.STRING_AFTER,
                                                                            (SELECT COUNT(*) FROM /*PREFIX*/COLUMN_PARAMS CP1 WHERE CP1.COLUMN_ID=CP.COLUMN_ID) AS PARAM_COUNT
                                                              FROM /*PREFIX*/PRESENTATION_COLUMNS PC
                                                              JOIN /*PREFIX*/COLUMNS C ON C.COLUMN_ID=PC.COLUMN_ID
                                                              JOIN /*PREFIX*/COLUMN_PARAMS CP ON CP.COLUMN_ID=C.COLUMN_ID
                                                              JOIN /*PREFIX*/PARAMS P ON P.PARAM_ID=CP.PARAM_ID
                                                              WHERE PC.PRESENTATION_ID=PRESENTATION_ID
                         ORDER BY PC.PRIORITY, CP.PRIORITY;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET DONE=1;                                                            
     
  SELECT P.TABLE_NAME INTO ATABLE
    FROM /*PREFIX*/PRESENTATIONS P
   WHERE P.PRESENTATION_ID=PRESENTATION_ID;
     
     SET @QUERY=CONCAT('DROP TABLE IF EXISTS /*PREFIX*/',ATABLE);
  PREPARE STMT FROM @QUERY;
  EXECUTE STMT;
  DEALLOCATE PREPARE STMT;

     SET @QUERY=CONCAT('CREATE TABLE /*PREFIX*/',ATABLE,' AS SELECT OP.OBJECT_ID,O.VIEW_ID,O.TYPE_ID,O.OPERATION_ID,');
     SET @QUERY=CONCAT(@QUERY,'O.DATE_BEGIN,O.ACCOUNT_ID,A.USER_NAME,A.PHONE');
     SET PARAM_IDS='';
     SET OLD_COLUMN_ID='';
     SET FIELD_NAME='';
     SET REAL_COUNT=0;
          
     OPEN C1;
  FETCH C1 INTO COLUMN_ID,COLUMN_NAME,PARAM_ID,PARAM_TYPE,STRING_BEFORE,STRING_AFTER,PARAM_COUNT;
  WHILE NOT DONE DO
     
          IF (OLD_COLUMN_ID<>COLUMN_ID) THEN
            SET REAL_COUNT=0;
          END IF;
          
          SET REAL_COUNT=REAL_COUNT+1;
          
       /*CASE 
          WHEN PARAM_TYPE=0 THEN SET FIELD_NAME=CONCAT('MIN(IF(OP.PARAM_ID=''',PARAM_ID,''',CONVERT(OP.VALUE USING cp1251),NULL))');
      WHEN PARAM_TYPE=2 THEN SET FIELD_NAME=CONCAT('MIN(IF(OP.PARAM_ID=''',PARAM_ID,''',CONVERT(OP.VALUE,SIGNED),NULL))');
      WHEN PARAM_TYPE=3 THEN SET FIELD_NAME=CONCAT('MIN(IF(OP.PARAM_ID=''',PARAM_ID,''',CONVERT(OP.VALUE,DECIMAL(15,2)),NULL))');
         ELSE SET NEW_QUERY='';
    END CASE;*/
          
          SET FIELD_NAME=CONCAT('MIN(IF(OP.PARAM_ID=''',
                                PARAM_ID,
                                                                 ''',CONCAT(''',
                                                                 IFNULL(STRING_BEFORE,''),
                                                                 ''',CONVERT(OP.VALUE USING cp1251),''',
                                                                 IFNULL(STRING_AFTER,''),
                                                                 '''),NULL))');
          
          IF (REAL_COUNT=PARAM_COUNT) THEN
            IF (PARAM_COUNT=1) THEN
              SET NEW_QUERY=FIELD_NAME;
               ELSE     
              SET NEW_QUERY=CONCAT(NEW_QUERY,',',FIELD_NAME,')');
            END IF;
            SET @QUERY=CONCAT(@QUERY,',',NEW_QUERY,' AS ''',COLUMN_NAME,'''');
               SET NEW_QUERY='';
          ELSE
            IF (REAL_COUNT=1) THEN
                 SET NEW_QUERY=CONCAT('CONCAT(',FIELD_NAME);
               ELSE     
                 SET NEW_QUERY=CONCAT(NEW_QUERY,',',FIELD_NAME);
               END IF;
          END IF;
                    
          IF TRIM(PARAM_IDS)='' THEN
            SET PARAM_IDS=CONCAT('''',PARAM_ID,''''); 
          ELSE
            SET PARAM_IDS=CONCAT(PARAM_IDS,',',CONCAT('''',PARAM_ID,'''')); 
          END IF;
          
          SET OLD_COLUMN_ID=COLUMN_ID;
          
    FETCH C1 INTO COLUMN_ID,COLUMN_NAME,PARAM_ID,PARAM_TYPE,STRING_BEFORE,STRING_AFTER,PARAM_COUNT;
  END WHILE;
  CLOSE C1;           

     SET @QUERY=CONCAT(@QUERY,' FROM /*PREFIX*/OBJECT_PARAMS OP ');
     SET @QUERY=CONCAT(@QUERY,'JOIN /*PREFIX*/OBJECTS O ON O.OBJECT_ID=OP.OBJECT_ID ');
     SET @QUERY=CONCAT(@QUERY,'JOIN /*PREFIX*/ACCOUNTS A ON A.ACCOUNT_ID=O.ACCOUNT_ID ');
     IF TRIM(PARAM_IDS)<>'' THEN
       SET @QUERY=CONCAT(@QUERY,'WHERE OP.PARAM_ID IN (',PARAM_IDS,') ');
          SET @QUERY=CONCAT(@QUERY,'AND OP.DATE_CREATE=(SELECT MAX(DATE_CREATE) FROM /*PREFIX*/OBJECT_PARAMS WHERE PARAM_ID=OP.PARAM_ID AND OBJECT_ID=O.OBJECT_ID) ');
       SET @QUERY=CONCAT(@QUERY,'AND O.VIEW_ID IN (SELECT VIEW_ID FROM /*PREFIX*/ACCOUNT_PRESENTATIONS WHERE PRESENTATION_ID=''',PRESENTATION_ID,''') ');
       SET @QUERY=CONCAT(@QUERY,'AND O.TYPE_ID IN (SELECT TYPE_ID FROM /*PREFIX*/ACCOUNT_PRESENTATIONS WHERE PRESENTATION_ID=''',PRESENTATION_ID,''') ');
       SET @QUERY=CONCAT(@QUERY,'AND O.OPERATION_ID IN (SELECT OPERATION_ID FROM /*PREFIX*/ACCOUNT_PRESENTATIONS WHERE PRESENTATION_ID=''',PRESENTATION_ID,''') ');
       SET @QUERY=CONCAT(@QUERY,'AND O.DATE_END IS NULL ');
       SET @QUERY=CONCAT(@QUERY,'AND O.STATUS=1 ');
          SET @QUERY=CONCAT(@QUERY,'GROUP BY OP.OBJECT_ID');

          PREPARE STMT FROM @QUERY;
    EXECUTE STMT;
    DEALLOCATE PREPARE STMT; 

    SET @QUERY=CONCAT('ALTER TABLE /*PREFIX*/',ATABLE,' ADD PRIMARY KEY (OBJECT_ID)');
          
          PREPARE STMT FROM @QUERY;
    EXECUTE STMT;
    DEALLOCATE PREPARE STMT; 
          
     END IF;     
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `R_PRESENTATIONS`(
)
BEGIN
  DECLARE PRESENTATION_ID VARCHAR(32);
	DECLARE DONE INTEGER DEFAULT 0;
	DECLARE C1 CURSOR FOR SELECT P.PRESENTATION_ID
  												FROM /*PREFIX*/PRESENTATIONS P;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET DONE=1;	
	
	OPEN C1;
  FETCH C1 INTO PRESENTATION_ID;
  WHILE NOT DONE DO
		CALL /*PREFIX*/R_PRESENTATION (PRESENTATION_ID);
    FETCH C1 INTO PRESENTATION_ID;
  END WHILE;
  CLOSE C1;		 
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `R_PRESENTATION_VIEWS`(
  IN TEST INTEGER
)
BEGIN

--  NULL;
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `U_ACCOUNT`(
  IN ACCOUNT_ID VARCHAR(32),
  IN FIRM_ID VARCHAR(32),
  IN USER_NAME VARCHAR(100),
  IN PASSWORD VARCHAR(100),
  IN DESCRIPTION VARCHAR(250),
  IN DB_USER_NAME VARCHAR(100),
  IN DB_PASSWORD VARCHAR(100),
  IN IS_ROLE INTEGER,
  IN LOCKED INTEGER,  
  IN AUTO_CREATED INTEGER,
  IN SURNAME VARCHAR(100),
  IN NAME VARCHAR(100),
  IN PATRONYMIC VARCHAR(100),
  IN PHONE VARCHAR(100),
  IN EMAIL VARCHAR(100),
  IN OLD_ACCOUNT_ID VARCHAR(32)
)
BEGIN
  UPDATE /*PREFIX*/ACCOUNTS A
     SET A.ACCOUNT_ID=ACCOUNT_ID,
         A.FIRM_ID=FIRM_ID,
         A.USER_NAME=USER_NAME,
         A.PASSWORD=PASSWORD,
         A.DESCRIPTION=DESCRIPTION,
         A.DB_USER_NAME=DB_USER_NAME,
         A.DB_PASSWORD=DB_PASSWORD,
         A.IS_ROLE=IS_ROLE,
				 A.LOCKED=LOCKED,
				 A.AUTO_CREATED=AUTO_CREATED,
				 A.SURNAME=SURNAME,
				 A.NAME=NAME,
				 A.PATRONYMIC=PATRONYMIC,
				 A.PHONE=PHONE,
				 A.EMAIL=EMAIL 
   WHERE A.ACCOUNT_ID=OLD_ACCOUNT_ID;
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `U_ACCOUNT_PARAM`(
  IN ACCOUNT_ID VARCHAR(32),
  IN PARAM_ID VARCHAR(32),
  IN PRIORITY INTEGER,
  IN OLD_ACCOUNT_ID VARCHAR(32),
  IN OLD_PARAM_ID VARCHAR(32)
)
BEGIN
  UPDATE /*PREFIX*/ACCOUNT_PARAMS AP
     SET AP.ACCOUNT_ID=ACCOUNT_ID,
         AP.PARAM_ID=PARAM_ID,
         AP.PRIORITY=PRIORITY
   WHERE AP.ACCOUNT_ID=OLD_ACCOUNT_ID
	   AND AP.PARAM_ID=OLD_PARAM_ID;
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `U_ACCOUNT_PRESENTATION`(
  IN ACCOUNT_ID VARCHAR(32),
  IN VIEW_ID VARCHAR(32),
  IN TYPE_ID VARCHAR(32),
  IN OPERATION_ID VARCHAR(32),
  IN PRESENTATION_ID VARCHAR(32),
	IN CONDITIONS VARCHAR(250),
  IN OLD_ACCOUNT_ID VARCHAR(32),
  IN OLD_VIEW_ID VARCHAR(32),
  IN OLD_TYPE_ID VARCHAR(32),
  IN OLD_OPERATION_ID VARCHAR(32)
)
BEGIN
  UPDATE /*PREFIX*/ACCOUNT_PRESENTATIONS AP
     SET AP.ACCOUNT_ID=ACCOUNT_ID,
		     AP.VIEW_ID=VIEW_ID,
		     AP.TYPE_ID=TYPE_ID,
		     AP.OPERATION_ID=OPERATION_ID,
		     AP.PRESENTATION_ID=PRESENTATION_ID,
         AP.CONDITIONS=CONDITIONS
   WHERE AP.ACCOUNT_ID=OLD_ACCOUNT_ID
	   AND AP.VIEW_ID=OLD_VIEW_ID
	   AND AP.TYPE_ID=OLD_TYPE_ID
	   AND AP.OPERATION_ID=OLD_OPERATION_ID;
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `U_ACCOUNT_ROLE`(
  IN ROLE_ID VARCHAR(32),
  IN ACCOUNT_ID VARCHAR(32),
  IN OLD_ROLE_ID VARCHAR(32),
  IN OLD_ACCOUNT_ID VARCHAR(32)
)
BEGIN
  UPDATE /*PREFIX*/ACCOUNT_ROLES AR
     SET AR.ROLE_ID=ROLE_ID,
         AR.ACCOUNT_ID=ACCOUNT_ID
   WHERE AR.ROLE_ID=OLD_ROLE_ID
	   AND AR.ACCOUNT_ID=OLD_ACCOUNT_ID;
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `U_APPLICATION`(
  IN APPLICATION_ID VARCHAR(32),
  IN NAME VARCHAR(100),
  IN DESCRIPTION VARCHAR(250),
	IN LOCKED INTEGER,
  IN OLD_APPLICATION_ID VARCHAR(32)
)
BEGIN
  UPDATE /*PREFIX*/APPLICATIONS V
     SET V.APPLICATION_ID=APPLICATION_ID,
         V.NAME=NAME,
	       V.DESCRIPTION=DESCRIPTION,
				 V.LOCKED=LOCKED
   WHERE V.APPLICATION_ID=OLD_APPLICATION_ID;
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `U_APPLICATION_INTERFACE`(
  IN APPLICATION_ID VARCHAR(32),
  IN INTERFACE_ID VARCHAR(32),
  IN PRIORITY INTEGER,
	IN AUTO_RUN INTEGER,
  IN OLD_APPLICATION_ID VARCHAR(32),
  IN OLD_INTERFACE_ID VARCHAR(32)
)
BEGIN
  UPDATE /*PREFIX*/APPLICATION_INTERFACES AI
     SET AI.APPLICATION_ID=APPLICATION_ID,
         AI.INTERFACE_ID=INTERFACE_ID,
         AI.PRIORITY=PRIORITY,
				 AI.AUTO_RUN=AUTO_RUN
   WHERE AI.APPLICATION_ID=OLD_APPLICATION_ID
	   AND AI.INTERFACE_ID=OLD_INTERFACE_ID;
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `U_COLUMN`(
  IN COLUMN_ID VARCHAR(32),
  IN NAME VARCHAR(100),
  IN DESCRIPTION VARCHAR(250),
	IN HTML_HEAD VARCHAR(100),
	IN HTML_DATA VARCHAR(100),
  IN OLD_COLUMN_ID VARCHAR(32)
)
BEGIN
  UPDATE /*PREFIX*/COLUMNS O
     SET O.COLUMN_ID=COLUMN_ID,
         O.NAME=NAME,
	       O.DESCRIPTION=DESCRIPTION,
				 O.HTML_HEAD=HTML_HEAD,
				 O.HTML_DATA=HTML_DATA
   WHERE O.COLUMN_ID=OLD_COLUMN_ID;
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `U_COLUMN_PARAM`(
  IN COLUMN_ID VARCHAR(32),
  IN PARAM_ID VARCHAR(32),
  IN PRIORITY INTEGER,
	IN STRING_BEFORE VARCHAR(100),
	IN STRING_AFTER VARCHAR(100),
  IN OLD_COLUMN_ID VARCHAR(32),
  IN OLD_PARAM_ID VARCHAR(32)
)
BEGIN
  UPDATE /*PREFIX*/COLUMN_PARAMS CP
     SET CP.COLUMN_ID=COLUMN_ID,
		     CP.PARAM_ID=PARAM_ID,
         CP.PRIORITY=PRIORITY,
         CP.STRING_BEFORE=STRING_BEFORE,
         CP.STRING_AFTER=STRING_AFTER
   WHERE CP.COLUMN_ID=OLD_COLUMN_ID
	   AND CP.PARAM_ID=OLD_PARAM_ID;
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `U_FIRM`(
  IN FIRM_ID VARCHAR(32),
  IN FIRM_TYPE_ID VARCHAR(32),
  IN PARENT_ID VARCHAR(32),
  IN SMALL_NAME VARCHAR(250),
  IN FULL_NAME VARCHAR(250),
  IN INN VARCHAR(12),
  IN PAYMENT_ACCOUNT VARCHAR(20),
  IN BANK VARCHAR(250),
  IN BIK VARCHAR(20),
  IN CORR_ACCOUNT VARCHAR(20),
  IN LEGAL_ADDRESS VARCHAR(250),
  IN POST_ADDRESS VARCHAR(250),
  IN PHONE VARCHAR(250),
  IN FAX VARCHAR(250),
  IN EMAIL VARCHAR(100),
  IN SITE VARCHAR(100),
  IN OKONH VARCHAR(20),
  IN OKPO VARCHAR(20),
  IN KPP VARCHAR(20),
  IN DIRECTOR VARCHAR(250),
  IN ACCOUNTANT VARCHAR(250),
  IN OLD_FIRM_ID VARCHAR(32)
)
BEGIN
  UPDATE /*PREFIX*/FIRMS F
     SET F.FIRM_ID=FIRM_ID,
         F.FIRM_TYPE_ID=FIRM_TYPE_ID,
				 F.PARENT_ID=PARENT_ID,
				 F.SMALL_NAME=SMALL_NAME,
				 F.FULL_NAME=FULL_NAME,
				 F.INN=INN,
				 F.PAYMENT_ACCOUNT=PAYMENT_ACCOUNT,
         F.BANK=BANK,
				 F.BIK=BIK,
				 F.CORR_ACCOUNT=CORR_ACCOUNT,
				 F.LEGAL_ADDRESS=LEGAL_ADDRESS,
				 F.POST_ADDRESS=POST_ADDRESS,
				 F.PHONE=PHONE,
				 F.FAX=FAX,
				 F.EMAIL=EMAIL,
				 F.SITE=SITE,
  			 F.OKONH=OKONH,
				 F.OKPO=OKPO,
				 F.KPP=KPP,
				 F.DIRECTOR=DIRECTOR,
				 F.ACCOUNTANT=ACCOUNTANT
   WHERE F.FIRM_ID=OLD_FIRM_ID;
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `U_FIRM_TYPE`(
  IN FIRM_TYPE_ID VARCHAR(32),
  IN NAME VARCHAR(100),
  IN DESCRIPTION VARCHAR(250),
	IN PRIORITY INTEGER,
  IN OLD_FIRM_TYPE_ID VARCHAR(32)
)
BEGIN
  UPDATE /*PREFIX*/FIRM_TYPES V
     SET V.FIRM_TYPE_ID=FIRM_TYPE_ID,
         V.NAME=NAME,
	       V.DESCRIPTION=DESCRIPTION,
				 V.PRIORITY=PRIORITY
   WHERE V.FIRM_TYPE_ID=OLD_FIRM_TYPE_ID;
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `U_INTERFACE`(
  IN INTERFACE_ID VARCHAR(32),
  IN NAME VARCHAR(100),
  IN DESCRIPTION VARCHAR(250),
  IN INTERNAL INTEGER,
  IN INTERFACE_CLASS VARCHAR(100),
	IN MODULE_NAME VARCHAR(100),
	IN MODULE_INTERFACE VARCHAR(250),
  IN OLD_INTERFACE_ID VARCHAR(32)
)
BEGIN
  UPDATE /*PREFIX*/INTERFACES I
     SET I.INTERFACE_ID=INTERFACE_ID,
         I.NAME=NAME,
         I.DESCRIPTION=DESCRIPTION,
         I.INTERNAL=INTERNAL,
	       I.INTERFACE_CLASS=INTERFACE_CLASS,
				 I.MODULE_NAME=MODULE_NAME,
				 I.MODULE_INTERFACE=MODULE_INTERFACE
   WHERE I.INTERFACE_ID=OLD_INTERFACE_ID;
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `U_OBJECT`(
  IN OBJECT_ID VARCHAR(32),
  IN ACCOUNT_ID VARCHAR(32),
  IN VIEW_ID VARCHAR(32),
  IN TYPE_ID VARCHAR(32),
  IN OPERATION_ID VARCHAR(32),
	IN DATE_BEGIN DATETIME,
	IN DATE_END DATETIME,
	IN STATUS INTEGER,
	IN OLD_OBJECT_ID VARCHAR(32)
)
BEGIN
  UPDATE /*PREFIX*/OBJECTS O
     SET O.OBJECT_ID=OBJECT_ID,
         O.ACCOUNT_ID=ACCOUNT_ID,
         O.VIEW_ID=VIEW_ID,
				 O.TYPE_ID=TYPE_ID,
				 O.OPERATION_ID=OPERATION_ID,
				 O.DATE_BEGIN=DATE_BEGIN,
				 O.DATE_END=DATE_END,
				 O.STATUS=STATUS
   WHERE O.OBJECT_ID=OLD_OBJECT_ID;
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `U_OBJECT_PARAM`(
  IN OBJECT_PARAM_ID VARCHAR(32),
  IN ACCOUNT_ID VARCHAR(32),
  IN PARAM_ID VARCHAR(32),
  IN OBJECT_ID VARCHAR(32),
  IN DATE_CREATE DATETIME,
  IN VALUE LONGBLOB,
	IN DESCRIPTION VARCHAR(250),
  IN OLD_OBJECT_PARAM_ID VARCHAR(32)
)
BEGIN
  UPDATE /*PREFIX*/OBJECT_PARAMS OP
     SET OP.OBJECT_PARAM_ID=OBJECT_PARAM_ID,
         OP.ACCOUNT_ID=ACCOUNT_ID,
         OP.PARAM_ID=PARAM_ID,
	       OP.OBJECT_ID=OBJECT_ID,
	       OP.DATE_CREATE=DATE_CREATE,
	       OP.VALUE=VALUE,
				 OP.DESCRIPTION=DESCRIPTION
   WHERE OP.OBJECT_PARAM_ID=OLD_OBJECT_PARAM_ID;
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `U_OPERATION`(
  IN OPERATION_ID VARCHAR(32),
  IN NAME VARCHAR(100),
  IN DESCRIPTION VARCHAR(250),
	IN PRIORITY INTEGER,
  IN OLD_OPERATION_ID VARCHAR(32)
)
BEGIN
  UPDATE /*PREFIX*/OPERATIONS O
     SET O.OPERATION_ID=OPERATION_ID,
         O.NAME=NAME,
	       O.DESCRIPTION=DESCRIPTION,
				 O.PRIORITY=PRIORITY
   WHERE O.OPERATION_ID=OLD_OPERATION_ID;
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `U_PARAM`(
  IN PARAM_ID VARCHAR(32),
  IN NAME VARCHAR(100),
  IN DESCRIPTION VARCHAR(250),
  IN PARAM_TYPE INTEGER,
  IN IS_NULL INTEGER,
  IN FORMAT VARCHAR(100),
  IN OLD_PARAM_ID VARCHAR(32)
)
BEGIN
  UPDATE /*PREFIX*/PARAMS P
     SET P.PARAM_ID=PARAM_ID,
         P.NAME=NAME,
	       P.DESCRIPTION=DESCRIPTION,
				 P.PARAM_TYPE=PARAM_TYPE,
				 P.IS_NULL=IS_NULL,
				 P.FORMAT=FORMAT
   WHERE P.PARAM_ID=OLD_PARAM_ID;
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `U_PARAM_VALUE`(
  IN PARAM_VALUE_ID VARCHAR(32),
  IN PARAM_ID VARCHAR(32),
  IN NAME VARCHAR(100),
  IN DESCRIPTION VARCHAR(250),
	IN PRIORITY INTEGER,
  IN OLD_PARAM_VALUE_ID VARCHAR(32)
)
BEGIN
  UPDATE /*PREFIX*/PARAM_VALUES PV
     SET PV.PARAM_VALUE_ID=PARAM_VALUE_ID,
         PV.PARAM_ID=PARAM_ID,
         PV.NAME=NAME,
	       PV.DESCRIPTION=DESCRIPTION,
				 PV.PRIORITY=PRIORITY
   WHERE PV.PARAM_VALUE_ID=OLD_PARAM_VALUE_ID;
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `U_PARAM_VALUE_DEPEND`(
  IN WHAT_PARAM_VALUE_ID VARCHAR(32),
  IN FROM_PARAM_VALUE_ID VARCHAR(32),
  IN OLD_WHAT_PARAM_VALUE_ID VARCHAR(32),
  IN OLD_FROM_PARAM_VALUE_ID VARCHAR(32)
)
BEGIN
  UPDATE /*PREFIX*/PARAM_VALUE_DEPENDS PVD
     SET PVD.WHAT_PARAM_VALUE_ID=WHAT_PARAM_VALUE_ID,
         PVD.FROM_PARAM_VALUE_ID=FROM_PARAM_VALUE_ID
   WHERE PVD.WHAT_PARAM_VALUE_ID=OLD_WHAT_PARAM_VALUE_ID
	   AND PVD.FROM_PARAM_VALUE_ID=OLD_FROM_PARAM_VALUE_ID;
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `U_PARAM_VALUE_VARIANT`(
  IN PARAM_VALUE_ID VARCHAR(32),
  IN VALUE VARCHAR(100),
  IN PRIORITY INTEGER,
	IN OLD_PARAM_VALUE_ID VARCHAR(32),
  IN OLD_VALUE VARCHAR(100)
)
BEGIN
  UPDATE /*PREFIX*/PARAM_VALUE_VARIANTS PVV
     SET PVV.PARAM_VALUE_ID=PARAM_VALUE_ID,
		     PVV.VALUE=VALUE,
         PVV.PRIORITY=PRIORITY
   WHERE PVV.PARAM_VALUE_ID=OLD_PARAM_VALUE_ID
	   AND PVV.VALUE=OLD_VALUE;
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `U_PERMISSION`(
  IN PERMISSION_ID VARCHAR(32),
  IN ACCOUNT_ID VARCHAR(32),
	IN INTERFACE_ID VARCHAR(32),
  IN RIGHT_ACCESS VARCHAR(250),
	IN VALUE VARCHAR(250),
  IN OLD_PERMISSION_ID VARCHAR(32)
)
BEGIN
  UPDATE /*PREFIX*/PERMISSIONS P
     SET P.PERMISSION_ID=PERMISSION_ID,
         P.ACCOUNT_ID=ACCOUNT_ID,
         P.INTERFACE_ID=INTERFACE_ID,
         P.RIGHT_ACCESS=RIGHT_ACCESS,
				 P.VALUE=VALUE
   WHERE P.PERMISSION_ID=OLD_PERMISSION_ID;
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `U_PRESENTATION`(
  IN PRESENTATION_ID VARCHAR(32),
  IN NAME VARCHAR(100),
  IN DESCRIPTION VARCHAR(250),
	IN TABLE_NAME VARCHAR(100),
	IN SORTING VARCHAR(250),
  IN OLD_PRESENTATION_ID VARCHAR(32)
)
BEGIN
  UPDATE /*PREFIX*/PRESENTATIONS P
     SET P.PRESENTATION_ID=PRESENTATION_ID,
         P.NAME=NAME,
	       P.DESCRIPTION=DESCRIPTION,
				 P.TABLE_NAME=TABLE_NAME,
				 P.SORTING=SORTING
   WHERE P.PRESENTATION_ID=OLD_PRESENTATION_ID;
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `U_PRESENTATION_COLUMN`(
  IN PRESENTATION_ID VARCHAR(32),
  IN COLUMN_ID VARCHAR(32),
  IN PRIORITY INTEGER,
	IN COLUMN_GROUP INTEGER,
	IN STRING_BEFORE VARCHAR(100),
	IN STRING_AFTER VARCHAR(100),
  IN OLD_PRESENTATION_ID VARCHAR(32),
  IN OLD_COLUMN_ID VARCHAR(32)
)
BEGIN
  UPDATE /*PREFIX*/PRESENTATION_COLUMNS CP
     SET CP.PRESENTATION_ID=PRESENTATION_ID,
		     CP.COLUMN_ID=COLUMN_ID,
         CP.PRIORITY=PRIORITY,
         CP.COLUMN_GROUP=COLUMN_GROUP,
         CP.STRING_BEFORE=STRING_BEFORE,
         CP.STRING_AFTER=STRING_AFTER
   WHERE CP.PRESENTATION_ID=OLD_PRESENTATION_ID
	   AND CP.COLUMN_ID=OLD_COLUMN_ID;
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `U_PROFILE`(
  IN ACCOUNT_ID VARCHAR(32),
  IN APPLICATION_ID VARCHAR(32),
  IN PROFILE LONGBLOB,
  IN OLD_ACCOUNT_ID VARCHAR(32),
  IN OLD_APPLICATION_ID VARCHAR(32)
)
BEGIN
  UPDATE /*PREFIX*/PROFILES P
     SET P.ACCOUNT_ID=ACCOUNT_ID,
         P.APPLICATION_ID=APPLICATION_ID,
         P.PROFILE=PROFILE
   WHERE P.ACCOUNT_ID=OLD_ACCOUNT_ID
	   AND P.APPLICATION_ID=OLD_APPLICATION_ID;
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `U_SESSION`(
  IN SESSION_ID VARCHAR(32),
  IN ACCOUNT_ID VARCHAR(32),
	IN APPLICATION_ID VARCHAR(32),
  IN DATE_CREATE DATETIME,
	IN DATE_CHANGE DATETIME,
	IN PARAMS LONGBLOB,
  IN OLD_SESSION_ID VARCHAR(32)
)
BEGIN
  UPDATE /*PREFIX*/SESSIONS S
     SET S.SESSION_ID=SESSION_ID,
         S.ACCOUNT_ID=ACCOUNT_ID,
         S.APPLICATION_ID=APPLICATION_ID,
         S.DATE_CREATE=DATE_CREATE,
				 S.DATE_CHANGE=DATE_CHANGE,
				 S.PARAMS=PARAMS
   WHERE S.SESSION_ID=OLD_SESSION_ID;
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `U_TYPE`(
  IN TYPE_ID VARCHAR(32),
  IN NAME VARCHAR(100),
  IN DESCRIPTION VARCHAR(250),
	IN PRIORITY INTEGER,
	IN VISIBLE INTEGER,
  IN OLD_TYPE_ID VARCHAR(32)
)
BEGIN
  UPDATE /*PREFIX*/TYPES V
     SET V.TYPE_ID=TYPE_ID,
         V.NAME=NAME,
	       V.DESCRIPTION=DESCRIPTION,
				 V.PRIORITY=PRIORITY,
				 V.VISIBLE=VISIBLE
   WHERE V.TYPE_ID=OLD_TYPE_ID;
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `U_TYPE_PARAM`(
  IN TYPE_ID VARCHAR(32),
  IN PARAM_ID VARCHAR(32),
	IN OPERATION_ID VARCHAR(32),
	IN VISIBLE INTEGER,
	IN MAIN INTEGER,
  IN PRIORITY INTEGER,
  IN OLD_TYPE_ID VARCHAR(32),
  IN OLD_PARAM_ID VARCHAR(32),
	IN OLD_OPERATION_ID VARCHAR(32)
)
BEGIN
  UPDATE /*PREFIX*/TYPE_PARAMS PT
     SET PT.TYPE_ID=TYPE_ID,
		     PT.PARAM_ID=PARAM_ID,
		     PT.OPERATION_ID=OPERATION_ID,
				 PT.VISIBLE=VISIBLE,
				 PT.MAIN=MAIN,
         PT.PRIORITY=PRIORITY
   WHERE PT.TYPE_ID=OLD_TYPE_ID
	   AND PT.PARAM_ID=OLD_PARAM_ID
		 AND PT.OPERATION_ID=OLD_OPERATION_ID;
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `U_VIEW`(
  IN VIEW_ID VARCHAR(32),
  IN NAME VARCHAR(100),
  IN DESCRIPTION VARCHAR(250),
	IN PRIORITY INTEGER,
  IN OLD_VIEW_ID VARCHAR(32)
)
BEGIN
  UPDATE /*PREFIX*/VIEWS V
     SET V.VIEW_ID=VIEW_ID,
         V.NAME=NAME,
	       V.DESCRIPTION=DESCRIPTION,
				 V.PRIORITY=PRIORITY
   WHERE V.VIEW_ID=OLD_VIEW_ID;
END;

CREATE DEFINER=`BIS`@`%` PROCEDURE `U_VIEW_TYPE`(
  IN VIEW_ID VARCHAR(32),
  IN TYPE_ID VARCHAR(32),
  IN PRIORITY INTEGER,
  IN OLD_VIEW_ID VARCHAR(32),
  IN OLD_TYPE_ID VARCHAR(32)
)
BEGIN
  UPDATE /*PREFIX*/VIEW_TYPES VT
     SET VT.VIEW_ID=VIEW_ID,
         VT.TYPE_ID=TYPE_ID,
         VT.PRIORITY=PRIORITY
   WHERE VT.VIEW_ID=OLD_VIEW_ID
	   AND VT.TYPE_ID=OLD_TYPE_ID;
END;

ALTER TABLE `account_params`
  ADD FOREIGN KEY (`ACCOUNT_ID`) REFERENCES `accounts` (`ACCOUNT_ID`),
  ADD FOREIGN KEY (`PARAM_ID`) REFERENCES `params` (`PARAM_ID`);

ALTER TABLE `account_presentations`
  ADD FOREIGN KEY (`ACCOUNT_ID`) REFERENCES `accounts` (`ACCOUNT_ID`),
  ADD FOREIGN KEY (`VIEW_ID`) REFERENCES `views` (`VIEW_ID`),
  ADD FOREIGN KEY (`TYPE_ID`) REFERENCES `types` (`TYPE_ID`),
  ADD FOREIGN KEY (`OPERATION_ID`) REFERENCES `operations` (`OPERATION_ID`),
  ADD FOREIGN KEY (`PRESENTATION_ID`) REFERENCES `presentations` (`PRESENTATION_ID`);

ALTER TABLE `account_roles`
  ADD FOREIGN KEY (`ROLE_ID`) REFERENCES `accounts` (`ACCOUNT_ID`),
  ADD FOREIGN KEY (`ACCOUNT_ID`) REFERENCES `accounts` (`ACCOUNT_ID`);

ALTER TABLE `application_interfaces`
  ADD FOREIGN KEY (`APPLICATION_ID`) REFERENCES `applications` (`APPLICATION_ID`),
  ADD FOREIGN KEY (`INTERFACE_ID`) REFERENCES `interfaces` (`INTERFACE_ID`);

ALTER TABLE `column_params`
  ADD FOREIGN KEY (`COLUMN_ID`) REFERENCES `columns` (`COLUMN_ID`),
  ADD FOREIGN KEY (`PARAM_ID`) REFERENCES `params` (`PARAM_ID`);

ALTER TABLE `firms`
  ADD FOREIGN KEY (`FIRM_TYPE_ID`) REFERENCES `firm_types` (`FIRM_TYPE_ID`),
  ADD FOREIGN KEY (`PARENT_ID`) REFERENCES `firms` (`FIRM_ID`);

ALTER TABLE `object_params`
  ADD FOREIGN KEY (`ACCOUNT_ID`) REFERENCES `accounts` (`ACCOUNT_ID`),
  ADD FOREIGN KEY (`PARAM_ID`) REFERENCES `params` (`PARAM_ID`),
  ADD FOREIGN KEY (`OBJECT_ID`) REFERENCES `objects` (`OBJECT_ID`);

ALTER TABLE `objects`
  ADD FOREIGN KEY (`VIEW_ID`) REFERENCES `views` (`VIEW_ID`),
  ADD FOREIGN KEY (`TYPE_ID`) REFERENCES `types` (`TYPE_ID`),
  ADD FOREIGN KEY (`ACCOUNT_ID`) REFERENCES `accounts` (`ACCOUNT_ID`),
  ADD FOREIGN KEY (`OPERATION_ID`) REFERENCES `operations` (`OPERATION_ID`);

ALTER TABLE `param_value_depends`
  ADD FOREIGN KEY (`WHAT_PARAM_VALUE_ID`) REFERENCES `param_values` (`PARAM_VALUE_ID`),
  ADD FOREIGN KEY (`FROM_PARAM_VALUE_ID`) REFERENCES `param_values` (`PARAM_VALUE_ID`);

ALTER TABLE `param_value_variants`
  ADD FOREIGN KEY (`PARAM_VALUE_ID`) REFERENCES `param_values` (`PARAM_VALUE_ID`);

ALTER TABLE `param_values`
  ADD FOREIGN KEY (`PARAM_ID`) REFERENCES `params` (`PARAM_ID`);

ALTER TABLE `permissions`
  ADD FOREIGN KEY (`ACCOUNT_ID`) REFERENCES `accounts` (`ACCOUNT_ID`),
  ADD FOREIGN KEY (`INTERFACE_ID`) REFERENCES `interfaces` (`INTERFACE_ID`);

ALTER TABLE `presentation_columns`
  ADD FOREIGN KEY (`PRESENTATION_ID`) REFERENCES `presentations` (`PRESENTATION_ID`),
  ADD FOREIGN KEY (`COLUMN_ID`) REFERENCES `columns` (`COLUMN_ID`);

ALTER TABLE `profiles`
  ADD FOREIGN KEY (`ACCOUNT_ID`) REFERENCES `accounts` (`ACCOUNT_ID`),
  ADD FOREIGN KEY (`APPLICATION_ID`) REFERENCES `applications` (`APPLICATION_ID`);

ALTER TABLE `sessions`
  ADD FOREIGN KEY (`ACCOUNT_ID`) REFERENCES `accounts` (`ACCOUNT_ID`),
  ADD FOREIGN KEY (`APPLICATION_ID`) REFERENCES `applications` (`APPLICATION_ID`);

ALTER TABLE `type_params`
  ADD FOREIGN KEY (`OPERATION_ID`) REFERENCES `operations` (`OPERATION_ID`);

ALTER TABLE `view_types`
  ADD FOREIGN KEY (`VIEW_ID`) REFERENCES `views` (`VIEW_ID`),
  ADD FOREIGN KEY (`TYPE_ID`) REFERENCES `types` (`TYPE_ID`),
  ADD FOREIGN KEY (`VIEW_ID`) REFERENCES `views` (`VIEW_ID`),
  ADD FOREIGN KEY (`TYPE_ID`) REFERENCES `types` (`TYPE_ID`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

