-- phpMyAdmin SQL Dump
-- version 5.2.1deb3
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: May 08, 2026 at 04:22 AM
-- Server version: 11.8.6-MariaDB-ubu2404
-- PHP Version: 8.2.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `tf_demo_tmp`
--

-- --------------------------------------------------------

--
-- Table structure for table `$App`
--

CREATE TABLE `$App` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\App';

-- --------------------------------------------------------

--
-- Table structure for table `$GroupRelations`
--

CREATE TABLE `$GroupRelations` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `Name` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Name',
  `$Subject` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Subject'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: QRelation';

-- --------------------------------------------------------

--
-- Table structure for table `$GroupRelations_Groups`
--

CREATE TABLE `$GroupRelations_Groups` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$$GroupRelations` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.$GroupRelations_Groups`.`Groups` column role',
  `$Groups` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Groups'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: QRelation.Groups';

-- --------------------------------------------------------

--
-- Table structure for table `$UserGroups`
--

CREATE TABLE `$UserGroups` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `Name` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Name',
  `$SelfUser` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: SelfUser'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: QUserGroup';

-- --------------------------------------------------------

--
-- Table structure for table `$UserGroups_Groups`
--

CREATE TABLE `$UserGroups_Groups` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$$UserGroups` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.$UserGroups_Groups`.`Groups` column role',
  `$Groups` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Groups'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: QUserGroup.Groups';

-- --------------------------------------------------------

--
-- Table structure for table `$UserGroups_Relations`
--

CREATE TABLE `$UserGroups_Relations` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$$UserGroups` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.$UserGroups_Relations`.`Relations` column role',
  `$Relations` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Relations'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: QUserGroup.Relations';

-- --------------------------------------------------------

--
-- Table structure for table `$Users`
--

CREATE TABLE `$Users` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Mail_Sender` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Mail_Sender',
  `Type` enum('H2B_Superadmin','H2B_Channel','H2B_Property','H2B_Customer') DEFAULT NULL COMMENT 'Column for property value: Type',
  `Access_Level` enum('Basic','Admin') DEFAULT 'Basic' COMMENT 'Column for property value: Access_Level',
  `$Reverse_APIs` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Reverse_APIs',
  `Confirmed_Activation` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Confirmed_Activation',
  `$TFH_API_System` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: TFH_API_System',
  `$Cart` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Cart',
  `$Access_Template` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Access_Template',
  `$Owner` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Owner',
  `$Favorite_Order` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Favorite_Order',
  `Access_To_All_Properties` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Access_To_All_Properties',
  `Access_Own_Orders_And_Offers` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Access_Own_Orders_And_Offers',
  `H2B_Channel_Type` enum('Agent','Administrator') DEFAULT NULL COMMENT 'Column for property value: H2B_Channel_Type',
  `BackendAccess` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: BackendAccess',
  `IsDefault` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: IsDefault',
  `Phone` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Phone',
  `Active` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Active',
  `ActivationCode` varchar(255) DEFAULT NULL COMMENT 'Column for property value: ActivationCode',
  `PasswordRecoveryCode` varchar(255) DEFAULT NULL COMMENT 'Column for property value: PasswordRecoveryCode',
  `PrevPwd` varchar(255) DEFAULT NULL COMMENT 'Column for property value: PrevPwd',
  `$Person` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Person',
  `LoggedToSystem` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: LoggedToSystem',
  `IsImportUser` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: IsImportUser',
  `Username` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Username',
  `IsRemoteCallUser` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: IsRemoteCallUser',
  `IsLegalRepresentative` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: IsLegalRepresentative',
  `Api_Key` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Api_Key',
  `Firstname` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Firstname',
  `$Language` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Language',
  `$UI_Language` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: UI_Language',
  `Name` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Name',
  `Email` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Email',
  `Password` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Password',
  `$SelfGroup` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: SelfGroup',
  `$_type` smallint(5) UNSIGNED DEFAULT NULL COMMENT 'Type column for table entry role',
  `$$App$Users` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.$Users`.`Users` column role'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\User[]';

-- --------------------------------------------------------

--
-- Table structure for table `$UsersGroupsList`
--

CREATE TABLE `$UsersGroupsList` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Group` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Groups',
  `$User` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.$UsersGroupsList`.`Groups` column role'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\User.Groups';

-- --------------------------------------------------------

--
-- Table structure for table `$Users_Access`
--

CREATE TABLE `$Users_Access` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$$Users` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.$Users_Access`.`Access` column role',
  `$Access` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Access'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\User.Access';

-- --------------------------------------------------------

--
-- Table structure for table `$Users_Authorized_IPs`
--

CREATE TABLE `$Users_Authorized_IPs` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$$Users` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.$Users_Authorized_IPs`.`Authorized_IPs` column role',
  `Authorized_IPs` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Authorized_IPs'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\User.Authorized_IPs';

-- --------------------------------------------------------

--
-- Table structure for table `$Users_Notifications`
--

CREATE TABLE `$Users_Notifications` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$$Users` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.$Users_Notifications`.`Notifications` column role',
  `$Notifications` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Notifications'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\User.Notifications';

-- --------------------------------------------------------

--
-- Table structure for table `Account_Configurations`
--

CREATE TABLE `Account_Configurations` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$$App$Account_Configurations` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Account_Configurations`.`Account_Configurations` column role',
  `Set_Company_Data` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Set_Company_Data',
  `Create_Property` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Create_Property',
  `Set_Age_Intervals` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Set_Age_Intervals',
  `Create_Occupancy` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Create_Occupancy',
  `Create_Room` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Create_Room',
  `Create_Meal_Services` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Create_Meal_Services',
  `Set_Payment_Policy` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Set_Payment_Policy',
  `Set_Cancellation_Policy` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Set_Cancellation_Policy',
  `Create_Rate_Plan` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Create_Rate_Plan',
  `Add_Rate_Set_Request` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Add_Rate_Set_Request',
  `Active` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Active',
  `$Owner` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Owner'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Account_Configuration';

-- --------------------------------------------------------

--
-- Table structure for table `Addresses`
--

CREATE TABLE `Addresses` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$City` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Addresses`.`Addresses` column role',
  `$County` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: County',
  `$Country` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Country',
  `PostCode` varchar(255) DEFAULT NULL COMMENT 'Column for property value: PostCode',
  `Street` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Street',
  `StreetNumber` varchar(255) DEFAULT NULL COMMENT 'Column for property value: StreetNumber',
  `Details` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Details',
  `Building` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Building',
  `BuildingPart` varchar(255) DEFAULT NULL COMMENT 'Column for property value: BuildingPart',
  `Organization` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Organization',
  `Premise` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Premise',
  `Caption` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Caption',
  `Longitude` float DEFAULT NULL COMMENT 'Column for property value: Longitude',
  `Latitude` float DEFAULT NULL COMMENT 'Column for property value: Latitude',
  `Place_Id` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Place_Id',
  `Place_Mtime` datetime DEFAULT NULL COMMENT 'Column for property value: Place_Mtime',
  `$Actor` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Addresses`.`Addresses` column role',
  `$$App$Addresses` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Addresses`.`Addresses` column role'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\Address[]';

-- --------------------------------------------------------

--
-- Table structure for table `Age_Intervals`
--

CREATE TABLE `Age_Intervals` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `Name` enum('infant','toddler','child','adolescent','adult') DEFAULT NULL COMMENT 'Column for property value: Name',
  `From` int(11) DEFAULT NULL COMMENT 'Column for property value: From',
  `To` int(11) DEFAULT NULL COMMENT 'Column for property value: To',
  `Active` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Active',
  `$Property` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Property',
  `$Owner` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Owner',
  `$$App$Age_Intervals` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Age_Intervals`.`Age_Intervals` column role'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\Comm\\Age_Interval[]';

-- --------------------------------------------------------

--
-- Table structure for table `API_Systems`
--

CREATE TABLE `API_Systems` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `Name` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Name',
  `Order` int(11) DEFAULT NULL COMMENT 'Column for property value: Order',
  `Default_Status_Is_Open_For_Room_Rate` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Default_Status_Is_Open_For_Room_Rate',
  `Reverse_API_Default_Setup` text DEFAULT NULL COMMENT 'Column for property value: Reverse_API_Default_Setup',
  `Do_On_Price_Zero` enum('no-action','close-rate-plan','unset-rate-plan-status','delete-rate-plan') DEFAULT NULL COMMENT 'Column for property value: Do_On_Price_Zero',
  `Room_Status_From_Count` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Room_Status_From_Count',
  `$$App$API_Systems` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.API_Systems`.`API_Systems` column role'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\API_System[]';

-- --------------------------------------------------------

--
-- Table structure for table `Bank_Accounts`
--

CREATE TABLE `Bank_Accounts` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `Use_On_Invoice` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Use_On_Invoice',
  `Bank_Name` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Bank_Name',
  `IBAN` varchar(255) DEFAULT NULL COMMENT 'Column for property value: IBAN',
  `Currency` enum('RON','EUR','USD') DEFAULT NULL COMMENT 'Column for property value: Currency'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\Comm\\Bank_Account';

-- --------------------------------------------------------

--
-- Table structure for table `BNR_Rates`
--

CREATE TABLE `BNR_Rates` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `From_Currency` varchar(255) DEFAULT NULL COMMENT 'Column for property value: From_Currency',
  `To_Currency` varchar(255) DEFAULT NULL COMMENT 'Column for property value: To_Currency',
  `Rate` float DEFAULT NULL COMMENT 'Column for property value: Rate',
  `Date` datetime DEFAULT NULL COMMENT 'Column for property value: Date'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\BNR_Rate';

-- --------------------------------------------------------

--
-- Table structure for table `Cache_View`
--

CREATE TABLE `Cache_View` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$$App$Cache_Views` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Cache_View`.`Cache_Views` column role',
  `Name` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Name'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Cache_View';

-- --------------------------------------------------------

--
-- Table structure for table `Cancellation_Policies`
--

CREATE TABLE `Cancellation_Policies` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `Remote_Id` varchar(65) DEFAULT NULL COMMENT 'Column for property value: Remote_Id',
  `Name` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Name',
  `Fee_Mode` enum('per_stay','per_person') DEFAULT NULL COMMENT 'Column for property value: Fee_Mode',
  `$Owner` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Owner',
  `$$App$Cancellation_Policies` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Cancellation_Policies`.`Cancellation_Policies` column role'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Cancellation_Policy[]';

-- --------------------------------------------------------

--
-- Table structure for table `Cancellation_Policies_Items`
--

CREATE TABLE `Cancellation_Policies_Items` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Cancellation_Policies` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Cancellation_Policies_Items`.`Items` column role',
  `$Items` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Items'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\TFH\\Cancellation_Policy.Items';

-- --------------------------------------------------------

--
-- Table structure for table `Channel_Contract`
--

CREATE TABLE `Channel_Contract` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Property` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Property',
  `$Channel` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Channel_Contract`.`Channel_Contracts` column role',
  `Contract_Was_Signed` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Contract_Was_Signed',
  `Terms_Accepted` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Terms_Accepted',
  `Terms_Accepted_File` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Terms_Accepted_File',
  `Terms_Accepted_Date` datetime DEFAULT NULL COMMENT 'Column for property value: Terms_Accepted_Date',
  `Terms_Accepted_IP` varchar(32) DEFAULT NULL COMMENT 'Column for property value: Terms_Accepted_IP',
  `$Terms_Accepted_User` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Terms_Accepted_User',
  `Contract_Signed_Date` datetime DEFAULT NULL COMMENT 'Column for property value: Contract_Signed_Date',
  `Contract_Signed_IP` varchar(32) DEFAULT NULL COMMENT 'Column for property value: Contract_Signed_IP',
  `$Contract_Signed_User` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Contract_Signed_User',
  `Pay_At_Term` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Pay_At_Term',
  `Days_Until_Payment` int(11) DEFAULT NULL COMMENT 'Column for property value: Days_Until_Payment',
  `Signed_Contract` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Signed_Contract',
  `Enable_Channel` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Enable_Channel',
  `Property_Signed_Contract` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Property_Signed_Contract',
  `Custom_Comission` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Custom_Comission',
  `Comission` float DEFAULT NULL COMMENT 'Column for property value: Comission',
  `Number_Int` int(11) DEFAULT NULL COMMENT 'Column for property value: Number_Int',
  `Number` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Number',
  `Agency_Enable_Channel` tinyint(1) DEFAULT 1 COMMENT 'Column for property value: Agency_Enable_Channel',
  `Agency_Commission_Enable` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Agency_Commission_Enable',
  `Agency_Commission` int(11) DEFAULT NULL COMMENT 'Column for property value: Agency_Commission'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Channel_Contract[]';

-- --------------------------------------------------------

--
-- Table structure for table `Channel_Corporate_Codes`
--

CREATE TABLE `Channel_Corporate_Codes` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `Name` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Name',
  `Codes` text DEFAULT NULL COMMENT 'Column for property value: Codes',
  `$Owner` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Owner',
  `$$App$Channel_Corporate_Codes` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Channel_Corporate_Codes`.`Channel_Corporate_Codes` column role'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Channel_Corporate_Code[]';

-- --------------------------------------------------------

--
-- Table structure for table `Checkout_Orders`
--

CREATE TABLE `Checkout_Orders` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$$App$Checkout_Orders` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Checkout_Orders`.`Checkout_Orders` column role',
  `$Buyer` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Buyer',
  `$Buyer_Company` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Buyer_Company',
  `$Created_By` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Created_By',
  `$Beneficiary_Company` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Beneficiary_Company'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Checkout_Orders';

-- --------------------------------------------------------

--
-- Table structure for table `Checkout_Orders_Offers`
--

CREATE TABLE `Checkout_Orders_Offers` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Checkout_Orders` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Checkout_Orders_Offers`.`Offers` column role',
  `$Offers` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Offers'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\TFH\\Checkout_Orders.Offers';

-- --------------------------------------------------------

--
-- Table structure for table `Cities`
--

CREATE TABLE `Cities` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `TFH_Block_Search` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: TFH_Block_Search',
  `TFH_Show_In_Search_List` tinyint(1) DEFAULT 1 COMMENT 'Column for property value: TFH_Show_In_Search_List',
  `$TFH_Search_City` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: TFH_Search_City',
  `Name` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Name',
  `Code` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Code',
  `$County` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: County',
  `$Country` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Country',
  `Place_Id` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Place_Id',
  `Place_Mtime` datetime DEFAULT NULL COMMENT 'Column for property value: Place_Mtime',
  `$$App$Cities` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Cities`.`Cities` column role'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\City[]';

-- --------------------------------------------------------

--
-- Table structure for table `Cities_TFH_Search_Cities`
--

CREATE TABLE `Cities_TFH_Search_Cities` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Cities` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: TFH_Alias_Search_Cities',
  `$TFH_Search_Cities` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Cities_TFH_Search_Cities`.`TFH_Alias_Search_Cities` column role'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\City.TFH_Alias_Search_Cities';

-- --------------------------------------------------------

--
-- Table structure for table `Cities_TFH_Search_Properties`
--

CREATE TABLE `Cities_TFH_Search_Properties` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Cities` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: TFH_Alias_Search_Cities',
  `$TFH_Search_Properties` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Cities_TFH_Search_Properties`.`TFH_Alias_Search_Cities` column role'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\TFH\\Property.TFH_Alias_Search_Cities';

-- --------------------------------------------------------

--
-- Table structure for table `Companies`
--

CREATE TABLE `Companies` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `Is_Property_Owner` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Is_Property_Owner',
  `Is_Channel_Owner` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Is_Channel_Owner',
  `Is_Customer` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Is_Customer',
  `Is_Partner_Manager` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Is_Partner_Manager',
  `Api_Key` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Api_Key',
  `Tourism_License` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Tourism_License',
  `Tourism_License_Number` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Tourism_License_Number',
  `Tourism_License_Issued_Date` date DEFAULT NULL COMMENT 'Column for property value: Tourism_License_Issued_Date',
  `Agency_Name` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Agency_Name',
  `Terms_Accepted` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Terms_Accepted',
  `Terms_Accepted_IP` varchar(32) DEFAULT NULL COMMENT 'Column for property value: Terms_Accepted_IP',
  `Terms_Accepted_Date` datetime DEFAULT NULL COMMENT 'Column for property value: Terms_Accepted_Date',
  `$Logo` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Logo',
  `$Mail_Sender` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Mail_Sender',
  `Disable_Properties_On_API` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Disable_Properties_On_API',
  `VAT_Value` float DEFAULT NULL COMMENT 'Column for property value: VAT_Value',
  `$Customer_Of` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Customer_Of',
  `$Language_Email_Notifications` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Language_Email_Notifications',
  `Enable_Default_Agency_Commission` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Enable_Default_Agency_Commission',
  `Default_Agency_Commission` float DEFAULT NULL COMMENT 'Column for property value: Default_Agency_Commission',
  `Agency_Commission_If_Missing_Margin` float DEFAULT NULL COMMENT 'Column for property value: Agency_Commission_If_Missing_Margin',
  `Enable_Corporate_Codes` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Enable_Corporate_Codes',
  `Name` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Name',
  `Code` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Code',
  `Reg_No` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Reg_No',
  `VAT_No` varchar(255) DEFAULT NULL COMMENT 'Column for property value: VAT_No',
  `VAT_Payer` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: VAT_Payer',
  `$Address` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Address',
  `$$App$Companies` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Companies`.`Companies` column role'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\Comm\\Company[]';

-- --------------------------------------------------------

--
-- Table structure for table `Companies_Accessible_By`
--

CREATE TABLE `Companies_Accessible_By` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Companies` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Has_Access_To',
  `$Accessible_By` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Companies_Accessible_By`.`Has_Access_To` column role'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\Comm\\Company.Has_Access_To';

-- --------------------------------------------------------

--
-- Table structure for table `Companies_Api_IPs`
--

CREATE TABLE `Companies_Api_IPs` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Companies` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Companies_Api_IPs`.`Api_IPs` column role',
  `Api_IPs` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Api_IPs'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\Comm\\Company.Api_IPs';

-- --------------------------------------------------------

--
-- Table structure for table `Companies_Bank_Accounts`
--

CREATE TABLE `Companies_Bank_Accounts` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Companies` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Companies_Bank_Accounts`.`Bank_Accounts` column role',
  `$Bank_Accounts` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Bank_Accounts'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\Comm\\Company.Bank_Accounts';

-- --------------------------------------------------------

--
-- Table structure for table `Companies_Contacts`
--

CREATE TABLE `Companies_Contacts` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Companies` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Companies_Contacts`.`Contacts` column role',
  `$Contacts` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Contacts'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\Comm\\Company.Contacts';

-- --------------------------------------------------------

--
-- Table structure for table `Companies_Contact_Emails_List`
--

CREATE TABLE `Companies_Contact_Emails_List` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Companies` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Companies_Contact_Emails_List`.`Contact_Emails_List` column role',
  `$Contact_Emails_List` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Contact_Emails_List'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\Comm\\Company.Contact_Emails_List';

-- --------------------------------------------------------

--
-- Table structure for table `Companies_Contact_Phones_List`
--

CREATE TABLE `Companies_Contact_Phones_List` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Companies` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Companies_Contact_Phones_List`.`Contact_Phones_List` column role',
  `$Contact_Phones_List` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Contact_Phones_List'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\Comm\\Company.Contact_Phones_List';

-- --------------------------------------------------------

--
-- Table structure for table `Companies_Emails_List`
--

CREATE TABLE `Companies_Emails_List` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Companies` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Companies_Emails_List`.`Emails_List` column role',
  `Emails_List` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Emails_List'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\Comm\\Company.Emails_List';

-- --------------------------------------------------------

--
-- Table structure for table `Companies_Phones_List`
--

CREATE TABLE `Companies_Phones_List` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Companies` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Companies_Phones_List`.`Phones_List` column role',
  `Phones_List` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Phones_List'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\Comm\\Company.Phones_List';

-- --------------------------------------------------------

--
-- Table structure for table `Contact_Information`
--

CREATE TABLE `Contact_Information` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `Name` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Name',
  `Department` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Department',
  `IsDefault` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: IsDefault'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Contact_Information';

-- --------------------------------------------------------

--
-- Table structure for table `Content`
--

CREATE TABLE `Content` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `Name` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Name',
  `ShortDescription` varchar(255) DEFAULT NULL COMMENT 'Column for property value: ShortDescription',
  `Text_HTML` text DEFAULT NULL COMMENT 'Column for property value: Text_HTML'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\Comm\\Content';

-- --------------------------------------------------------

--
-- Table structure for table `Corporate_Codes`
--

CREATE TABLE `Corporate_Codes` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `Name` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Name',
  `Codes` varchar(2048) DEFAULT NULL COMMENT 'Column for property value: Codes',
  `Access_To_All` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Column for property value: Access_To_All',
  `$Owner` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Owner',
  `$$App$Corporate_Codes` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Corporate_Codes`.`Corporate_Codes` column role'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Corporate_Code[]';

-- --------------------------------------------------------

--
-- Table structure for table `Corporate_Codes_Accessible_To`
--

CREATE TABLE `Corporate_Codes_Accessible_To` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Corporate_Codes` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Corporate_Codes_Accessible_To`.`Accessible_To` column role',
  `$Accessible_To` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Accessible_To'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\TFH\\Corporate_Code.Accessible_To';

-- --------------------------------------------------------

--
-- Table structure for table `Corporate_Codes_Rate_Plans`
--

CREATE TABLE `Corporate_Codes_Rate_Plans` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Rate_Plans` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Rate_Plans',
  `$Corporate_Codes` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Corporate_Codes_Rate_Plans`.`Rate_Plans` column role'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\TFH\\Corporate_Code.Rate_Plans';

-- --------------------------------------------------------

--
-- Table structure for table `Counties`
--

CREATE TABLE `Counties` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `Code` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Code',
  `Name` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Name',
  `$Country` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Country',
  `Place_Id` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Place_Id',
  `Place_Mtime` datetime DEFAULT NULL COMMENT 'Column for property value: Place_Mtime',
  `$$App$Counties` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Counties`.`Counties` column role'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\County[]';

-- --------------------------------------------------------

--
-- Table structure for table `Countries`
--

CREATE TABLE `Countries` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `Name` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Name',
  `Code` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Code',
  `Place_Id` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Place_Id',
  `Place_Mtime` datetime DEFAULT NULL COMMENT 'Column for property value: Place_Mtime',
  `$$App$Countries` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Countries`.`Countries` column role'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\Country[]';

-- --------------------------------------------------------

--
-- Table structure for table `Dates_Intervals`
--

CREATE TABLE `Dates_Intervals` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Date_Interval';

-- --------------------------------------------------------

--
-- Table structure for table `Dates_Intervals_End_Date`
--

CREATE TABLE `Dates_Intervals_End_Date` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Dates_Intervals` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Dates_Intervals_End_Date`.`End_Date` column role',
  `End_Date` date DEFAULT NULL COMMENT 'Column for property value: End_Date'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\TFH\\Date_Interval.End_Date';

-- --------------------------------------------------------

--
-- Table structure for table `Dates_Intervals_Start_Date`
--

CREATE TABLE `Dates_Intervals_Start_Date` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Dates_Intervals` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Dates_Intervals_Start_Date`.`Start_Date` column role',
  `Start_Date` date DEFAULT NULL COMMENT 'Column for property value: Start_Date'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\TFH\\Date_Interval.Start_Date';

-- --------------------------------------------------------

--
-- Table structure for table `Date_Room`
--

CREATE TABLE `Date_Room` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$$App$Date_Room` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Date_Room`.`Date_Room` column role',
  `Date` date DEFAULT NULL COMMENT 'Column for property value: Date',
  `$Room` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Room',
  `Count` int(11) DEFAULT NULL COMMENT 'Column for property value: Count',
  `Booked` int(11) DEFAULT NULL COMMENT 'Column for property value: Booked',
  `Status` enum('open','closed','cancel') DEFAULT NULL COMMENT 'Column for property value: Status'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Date_Room';

-- --------------------------------------------------------

--
-- Table structure for table `Date_Room_Rate`
--

CREATE TABLE `Date_Room_Rate` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Rate` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Rate',
  `Price` float DEFAULT NULL COMMENT 'Column for property value: Price',
  `$Restrictions` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Restrictions'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Date_Room_Rate';

-- --------------------------------------------------------

--
-- Table structure for table `Date_Room_Rates`
--

CREATE TABLE `Date_Room_Rates` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Date_Room` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Date_Room_Rates`.`Rates` column role',
  `$Rates` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Rates'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\TFH\\Date_Room.Rates';

-- --------------------------------------------------------

--
-- Table structure for table `Documents`
--

CREATE TABLE `Documents` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `File` varchar(255) DEFAULT NULL COMMENT 'Column for property value: File',
  `IP` varchar(255) DEFAULT NULL COMMENT 'Column for property value: IP',
  `$User` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: User',
  `Date` datetime DEFAULT NULL COMMENT 'Column for property value: Date'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\Document';

-- --------------------------------------------------------

--
-- Table structure for table `DRR_Logs`
--

CREATE TABLE `DRR_Logs` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$$App$DRR_Logs` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.DRR_Logs`.`DRR_Logs` column role',
  `Date` datetime DEFAULT NULL COMMENT 'Column for property value: Date',
  `Location_Id` int(11) DEFAULT NULL COMMENT 'Column for property value: Location_Id',
  `Room_Id` int(11) DEFAULT NULL COMMENT 'Column for property value: Room_Id',
  `Rate_Plan_Id` int(11) DEFAULT NULL COMMENT 'Column for property value: Rate_Plan_Id',
  `Property_Index` int(11) DEFAULT NULL COMMENT 'Column for property value: Property_Index',
  `Room_Index` int(11) DEFAULT NULL COMMENT 'Column for property value: Room_Index',
  `Rate_Plan_Index` int(11) DEFAULT NULL COMMENT 'Column for property value: Rate_Plan_Index',
  `From` date DEFAULT NULL COMMENT 'Column for property value: From',
  `To` date DEFAULT NULL COMMENT 'Column for property value: To',
  `Weekdays_Mask` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Weekdays_Mask',
  `Price` float DEFAULT NULL COMMENT 'Column for property value: Price',
  `Rooms_Count` int(11) DEFAULT NULL COMMENT 'Column for property value: Rooms_Count',
  `Rooms_Status` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Rooms_Status',
  `Rate_Status` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Rate_Status',
  `Do_Delete` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Do_Delete',
  `Default_Status_Is_Open` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Default_Status_Is_Open',
  `Do_On_Price_Zero` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Do_On_Price_Zero',
  `Room_Status_From_Count` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Room_Status_From_Count',
  `Queries_Executed` mediumtext DEFAULT NULL COMMENT 'Column for property value: Queries_Executed',
  `Restrictions` varchar(2048) DEFAULT NULL COMMENT 'Column for property value: Restrictions',
  `$Request_Log` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Request_Log'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\DRR_Log';

-- --------------------------------------------------------

--
-- Table structure for table `Emails_Sent`
--

CREATE TABLE `Emails_Sent` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `Subject` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Subject',
  `Body` text DEFAULT NULL COMMENT 'Column for property value: Body',
  `From` varchar(255) DEFAULT NULL COMMENT 'Column for property value: From',
  `To` varchar(255) DEFAULT NULL COMMENT 'Column for property value: To',
  `Date` datetime DEFAULT NULL COMMENT 'Column for property value: Date'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Email_Sent';

-- --------------------------------------------------------

--
-- Table structure for table `Extra_Beds_Limits`
--

CREATE TABLE `Extra_Beds_Limits` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `Max_Cribs` int(11) DEFAULT NULL COMMENT 'Column for property value: Max_Cribs',
  `Max_Child_Beds` int(11) DEFAULT NULL COMMENT 'Column for property value: Max_Child_Beds',
  `Max_Adult_Beds` int(11) DEFAULT NULL COMMENT 'Column for property value: Max_Adult_Beds',
  `Max_Total` int(11) DEFAULT NULL COMMENT 'Column for property value: Max_Total',
  `$Room` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Room'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Extra_Beds_Limits';

-- --------------------------------------------------------

--
-- Table structure for table `FailedLogins`
--

CREATE TABLE `FailedLogins` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$$App$FailedLogins` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.FailedLogins`.`FailedLogins` column role',
  `LastTry` datetime DEFAULT NULL COMMENT 'Column for property value: LastTry',
  `Ip` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Ip',
  `Username` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Username',
  `Ban` datetime DEFAULT NULL COMMENT 'Column for property value: Ban',
  `Count` int(11) DEFAULT NULL COMMENT 'Column for property value: Count'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\FailedLogin';

-- --------------------------------------------------------

--
-- Table structure for table `Favorite_Orders`
--

CREATE TABLE `Favorite_Orders` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Created_By` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Created_By',
  `Date` datetime DEFAULT NULL COMMENT 'Column for property value: Date',
  `Offer_Number` int(11) DEFAULT NULL COMMENT 'Column for property value: Offer_Number',
  `$Owner` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Owner',
  `$$App$Favorite_Orders` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Favorite_Orders`.`Favorite_Orders` column role'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Favorite_Order[]';

-- --------------------------------------------------------

--
-- Table structure for table `Favorite_Orders_Favorite_Offers`
--

CREATE TABLE `Favorite_Orders_Favorite_Offers` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Favorite_Orders` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Favorite_Orders_Favorite_Offers`.`Favorite_Offers` column role',
  `$Favorite_Offers` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Favorite_Offers'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\TFH\\Favorite_Order.Favorite_Offers';

-- --------------------------------------------------------

--
-- Table structure for table `Favorite_Order_Email`
--

CREATE TABLE `Favorite_Order_Email` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$$App$Favorite_Order_Emails` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Favorite_Order_Email`.`Favorite_Order_Emails` column role',
  `$Favorite_Order` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Favorite_Order',
  `Email_Header_Text` text DEFAULT NULL COMMENT 'Column for property value: Email_Header_Text',
  `Email_Footer_Text` text DEFAULT NULL COMMENT 'Column for property value: Email_Footer_Text',
  `$Created_By` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Created_By',
  `Date` datetime DEFAULT NULL COMMENT 'Column for property value: Date'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Favorite_Order_Email';

-- --------------------------------------------------------

--
-- Table structure for table `Favorite_Order_Email_Emails`
--

CREATE TABLE `Favorite_Order_Email_Emails` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Favorite_Order_Email` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Favorite_Order_Email_Emails`.`Emails` column role',
  `Emails` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Emails'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\TFH\\Favorite_Order_Email.Emails';

-- --------------------------------------------------------

--
-- Table structure for table `Favorite_Order_Email_Favorite_Offers`
--

CREATE TABLE `Favorite_Order_Email_Favorite_Offers` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Favorite_Order_Email` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Favorite_Order_Email_Favorite_Offers`.`Favorite_Offers` column role',
  `$Favorite_Offers` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Favorite_Offers'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\TFH\\Favorite_Order_Email.Favorite_Offers';

-- --------------------------------------------------------

--
-- Table structure for table `General_Properties_Facilities`
--

CREATE TABLE `General_Properties_Facilities` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$$App$General_Properties_Facilities` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.General_Properties_Facilities`.`General_Properties_Facilities` column role',
  `Name` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Name',
  `Tag` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Tag',
  `Icon` text DEFAULT NULL COMMENT 'Column for property value: Icon'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Property_Facility';

-- --------------------------------------------------------

--
-- Table structure for table `General_Properties_Room_Facilities`
--

CREATE TABLE `General_Properties_Room_Facilities` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$$App$General_Properties_Room_Facilities` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.General_Properties_Room_Facilities`.`General_Properties_Room_Facilities` column role',
  `Name` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Name',
  `Tag` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Tag',
  `Icon` text DEFAULT NULL COMMENT 'Column for property value: Icon'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Property_Room_Facility';

-- --------------------------------------------------------

--
-- Table structure for table `Identities`
--

CREATE TABLE `Identities` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$$App$Identities` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Identities`.`Identities` column role',
  `$User` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: User',
  `$Session` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Session'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\Identity';

-- --------------------------------------------------------

--
-- Table structure for table `Invoices`
--

CREATE TABLE `Invoices` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$$App$Invoices` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Invoices`.`Invoices` column role',
  `Date` date DEFAULT NULL COMMENT 'Column for property value: Date',
  `Due_Days` int(11) DEFAULT NULL COMMENT 'Column for property value: Due_Days',
  `Due_Date` date DEFAULT NULL COMMENT 'Column for property value: Due_Date',
  `$Series_Number` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Series_Number',
  `Series` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Series',
  `Number` int(11) DEFAULT NULL COMMENT 'Column for property value: Number',
  `VAT` float DEFAULT NULL COMMENT 'Column for property value: VAT',
  `$Invoiced_By` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Invoiced_By',
  `Invoiced_To` enum('channel','property_owner') DEFAULT NULL COMMENT 'Column for property value: Invoiced_To',
  `$Invoiced_To_Channel` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Invoiced_To_Channel',
  `$Invoiced_To_Property_Owner` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Invoiced_To_Property_Owner',
  `$Made_By` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Made_By',
  `$Representative` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Representative',
  `Total_Price` float DEFAULT NULL COMMENT 'Column for property value: Total_Price',
  `Notes` text DEFAULT NULL COMMENT 'Column for property value: Notes',
  `Status` enum('issued','generated','partially_collected','collected','canceled','outdated') DEFAULT NULL COMMENT 'Column for property value: Status',
  `$Language` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Language',
  `$Owner` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Owner'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Invoice';

-- --------------------------------------------------------

--
-- Table structure for table `Invoices_Collected`
--

CREATE TABLE `Invoices_Collected` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$$App$Invoices_Collected` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Invoices_Collected`.`Invoices_Collected` column role',
  `Number` int(11) DEFAULT NULL COMMENT 'Column for property value: Number',
  `$Payment_Type` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Payment_Type',
  `Date` date DEFAULT NULL COMMENT 'Column for property value: Date',
  `$Invoice` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Invoice',
  `$Bank_Account` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Bank_Account',
  `Amount_Type` enum('total_cached','partially_cached') DEFAULT NULL COMMENT 'Column for property value: Amount_Type',
  `Amount_Value` float DEFAULT NULL COMMENT 'Column for property value: Amount_Value',
  `Currency_Type` enum('RON','EUR','USD','custom') DEFAULT NULL COMMENT 'Column for property value: Currency_Type',
  `Currency_Code` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Currency_Code',
  `$Client` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Client',
  `Status` enum('Invoiced') DEFAULT NULL COMMENT 'Column for property value: Status',
  `Notes` text DEFAULT NULL COMMENT 'Column for property value: Notes',
  `$Owner` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Owner'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Invoice_Collected';

-- --------------------------------------------------------

--
-- Table structure for table `Invoices_Items`
--

CREATE TABLE `Invoices_Items` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Invoices` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Invoices_Items`.`Items` column role',
  `$Items` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Items',
  `Name` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Name',
  `Quantity` float DEFAULT NULL COMMENT 'Column for property value: Quantity',
  `Measurement_Unit` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Measurement_Unit',
  `Price` float DEFAULT NULL COMMENT 'Column for property value: Price',
  `$VAT` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: VAT',
  `VAT_Included` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: VAT_Included',
  `$Owner` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Owner'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Invoice_Item';

-- --------------------------------------------------------

--
-- Table structure for table `Invoices_Orders`
--

CREATE TABLE `Invoices_Orders` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Invoices` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Invoices_Orders`.`Orders` column role',
  `$Orders` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Orders'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\TFH\\Invoice.Orders';

-- --------------------------------------------------------

--
-- Table structure for table `Invoices_Series`
--

CREATE TABLE `Invoices_Series` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `Name` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Name',
  `First_Number` int(11) DEFAULT 1 COMMENT 'Column for property value: First_Number',
  `Current_Number` int(11) DEFAULT NULL COMMENT 'Column for property value: Current_Number',
  `Description` text DEFAULT NULL COMMENT 'Column for property value: Description',
  `Default_Channel` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Default_Channel',
  `Default_Property_Owner` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Default_Property_Owner',
  `$Owner` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Owner',
  `$$App$Invoices_Series` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Invoices_Series`.`Invoices_Series` column role'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Invoice_Series[]';

-- --------------------------------------------------------

--
-- Table structure for table `Invoices_VAT_Rates`
--

CREATE TABLE `Invoices_VAT_Rates` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `Name` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Name',
  `Percent` int(11) DEFAULT NULL COMMENT 'Column for property value: Percent',
  `Default` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Default',
  `$Owner` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Owner',
  `$$App$Invoices_VAT_Rates` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Invoices_VAT_Rates`.`Invoices_VAT_Rates` column role'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Invoice_VAT_Rate[]';

-- --------------------------------------------------------

--
-- Table structure for table `Invoice_Payment_Types`
--

CREATE TABLE `Invoice_Payment_Types` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$$App$Invoice_Payment_Types` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Invoice_Payment_Types`.`Invoice_Payment_Types` column role',
  `Name` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Name',
  `Default` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Default',
  `$Owner` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Owner'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Invoice_Payment_Type';

-- --------------------------------------------------------

--
-- Table structure for table `Key_Value`
--

CREATE TABLE `Key_Value` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Rate_Set_Request` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Rate_Set_Request',
  `Key` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Key',
  `Value` varchar(1000) DEFAULT NULL COMMENT 'Column for property value: Value',
  `Value_Text` text DEFAULT NULL COMMENT 'Column for property value: Value_Text'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Key_Value';

-- --------------------------------------------------------

--
-- Table structure for table `Languages`
--

CREATE TABLE `Languages` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `Default` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Default',
  `Code` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Code',
  `Name` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Name',
  `$Owner` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Owner',
  `$$App$Languages_Spoken` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Languages`.`Languages_Spoken` column role',
  `$$App$Languages` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Languages`.`Languages` column role',
  `$$App$Invoice_Languages` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Languages`.`Invoice_Languages` column role'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\Language[]';

-- --------------------------------------------------------

--
-- Table structure for table `List_Offers`
--

CREATE TABLE `List_Offers` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$$App$List_Offers` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.List_Offers`.`List_Offers` column role',
  `$Search` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Search',
  `Limit_Offset` int(11) DEFAULT NULL COMMENT 'Column for property value: Limit_Offset',
  `Limit_Count` int(11) DEFAULT NULL COMMENT 'Column for property value: Limit_Count'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\List_Offers';

-- --------------------------------------------------------

--
-- Table structure for table `LoginLog`
--

CREATE TABLE `LoginLog` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$$App$LoginsLog` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.LoginLog`.`LoginsLog` column role',
  `$User` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: User',
  `UserData` text DEFAULT NULL COMMENT 'Column for property value: UserData',
  `SessionId` varchar(255) DEFAULT NULL COMMENT 'Column for property value: SessionId',
  `Date` datetime DEFAULT NULL COMMENT 'Column for property value: Date',
  `Ip` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Ip'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\LoginLog';

-- --------------------------------------------------------

--
-- Table structure for table `Mails_Senders`
--

CREATE TABLE `Mails_Senders` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `Email_Header_Text` text DEFAULT NULL COMMENT 'Column for property value: Email_Header_Text',
  `Email_Footer_Text` text DEFAULT NULL COMMENT 'Column for property value: Email_Footer_Text',
  `Host` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Host',
  `Port` int(11) DEFAULT NULL COMMENT 'Column for property value: Port',
  `Username` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Username',
  `Password` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Password',
  `Email` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Email',
  `Encryption` enum('tls','ssl') DEFAULT NULL COMMENT 'Column for property value: Encryption',
  `FromAlias` varchar(255) DEFAULT NULL COMMENT 'Column for property value: FromAlias',
  `Connection_Active` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Connection_Active',
  `$Owner` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Mails_Senders`.`Mail_Senders` column role'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\Mail_Sender[]';

-- --------------------------------------------------------

--
-- Table structure for table `Mails_Senders_ReplyTo`
--

CREATE TABLE `Mails_Senders_ReplyTo` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Mails_Senders` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Mails_Senders_ReplyTo`.`ReplyTo` column role',
  `ReplyTo` varchar(255) DEFAULT NULL COMMENT 'Column for property value: ReplyTo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\Mail_Sender.ReplyTo';

-- --------------------------------------------------------

--
-- Table structure for table `Notifications`
--

CREATE TABLE `Notifications` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `Title` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Title',
  `Details` text DEFAULT NULL COMMENT 'Column for property value: Details',
  `Date` date DEFAULT NULL COMMENT 'Column for property value: Date',
  `Level` enum('info','warning','alert') DEFAULT NULL COMMENT 'Column for property value: Level',
  `Dismiss` tinyint(1) DEFAULT 0 COMMENT 'Column for property value: Dismiss'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Notification';

-- --------------------------------------------------------

--
-- Table structure for table `Offers`
--

CREATE TABLE `Offers` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `Remote_Id` varchar(65) DEFAULT NULL COMMENT 'Column for property value: Remote_Id',
  `TFH_Type` enum('meal','extra_bed','other') DEFAULT NULL COMMENT 'Column for property value: TFH_Type',
  `TFH_Meal_Type` enum('none','breakfast','half_board','full_board','all_inclusive') DEFAULT NULL COMMENT 'Column for property value: TFH_Meal_Type',
  `TFH_Bed_Type` enum('none','adult','child','crib') DEFAULT NULL COMMENT 'Column for property value: TFH_Bed_Type',
  `TFH_Price_Mode` enum('price_per_stay','price_per_stay_per_person','price_per_night','price_per_night_per_person') DEFAULT NULL COMMENT 'Column for property value: TFH_Price_Mode',
  `TFH_PP_Mode_Property` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: TFH_PP_Mode_Property',
  `TFH_PP_Mode_Property_Rate` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: TFH_PP_Mode_Property_Rate',
  `TFH_PP_Mode_Property_Room` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: TFH_PP_Mode_Property_Room',
  `TFH_PP_Mode_Property_Room_Rate` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: TFH_PP_Mode_Property_Room_Rate',
  `From_Age` int(11) DEFAULT NULL COMMENT 'Column for property value: From_Age',
  `To_Age` int(11) DEFAULT NULL COMMENT 'Column for property value: To_Age',
  `Max_Quantity` int(11) DEFAULT NULL COMMENT 'Column for property value: Max_Quantity',
  `$TFH_Service_Calendar` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Offers`.`Services` column role',
  `Description_HTML` text DEFAULT NULL COMMENT 'Column for property value: Description_HTML',
  `Code` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Code',
  `Name` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Name',
  `$Category` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Category',
  `Type` enum('service','product','other') DEFAULT NULL COMMENT 'Column for property value: Type',
  `Is_Bundle` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Is_Bundle',
  `$Content` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Content',
  `$Owner` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Owner',
  `$$App$Offers` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Offers`.`Offers` column role'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\Comm\\Offer[]';

-- --------------------------------------------------------

--
-- Table structure for table `Offers_Bundle_Items`
--

CREATE TABLE `Offers_Bundle_Items` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Offers` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Offers_Bundle_Items`.`Bundle_Items` column role',
  `$Bundle_Items` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Bundle_Items'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\Comm\\Offer.Bundle_Items';

-- --------------------------------------------------------

--
-- Table structure for table `Offer_Category`
--

CREATE TABLE `Offer_Category` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `Code` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Code',
  `Name` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Name',
  `$$App$Offer_Categories` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Offer_Category`.`Offer_Categories` column role'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\Comm\\Offer_Category[]';

-- --------------------------------------------------------

--
-- Table structure for table `Offer_Discount`
--

CREATE TABLE `Offer_Discount` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Offer` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Offer',
  `TFH_Fixed` int(11) DEFAULT NULL COMMENT 'Column for property value: TFH_Fixed',
  `TFH_From_Age` int(11) DEFAULT NULL COMMENT 'Column for property value: TFH_From_Age',
  `TFH_To_Age` int(11) DEFAULT NULL COMMENT 'Column for property value: TFH_To_Age',
  `TFH_Age_Interval` enum('infant','toddler','child','adolescent','adult') DEFAULT NULL COMMENT 'Column for property value: TFH_Age_Interval',
  `Discount_Type` enum('percent','fixed') DEFAULT NULL COMMENT 'Column for property value: Discount_Type',
  `Percent` float DEFAULT NULL COMMENT 'Column for property value: Percent',
  `Fixed` float DEFAULT NULL COMMENT 'Column for property value: Fixed'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\Comm\\Offer_Discount';

-- --------------------------------------------------------

--
-- Table structure for table `Offer_Enforcements`
--

CREATE TABLE `Offer_Enforcements` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Offer` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Offer',
  `Order_By` int(11) DEFAULT NULL COMMENT 'Column for property value: Order_By',
  `Is_Default` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Is_Default'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\Comm\\Offer_Enforcement';

-- --------------------------------------------------------

--
-- Table structure for table `Offer_Enforcements_Offer_Enforcement_Items`
--

CREATE TABLE `Offer_Enforcements_Offer_Enforcement_Items` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Offer_Enforcements` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Offer_Enforcements_Offer_Enforcement_Items`.`Offer_Enforcement_Items` column role',
  `$Offer_Enforcement_Items` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Offer_Enforcement_Items'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\Comm\\Offer_Enforcement.Offer_Enforcement_Items';

-- --------------------------------------------------------

--
-- Table structure for table `Offer_Enforcement_Items`
--

CREATE TABLE `Offer_Enforcement_Items` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `Condition` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Condition',
  `Formula` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Formula',
  `$Offer_Enforcement` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Offer_Enforcement',
  `$Offer` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Offer',
  `Quantity` int(11) DEFAULT NULL COMMENT 'Column for property value: Quantity',
  `$Discount` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Discount',
  `Action` enum('mandatory','incompatible','discount','set_price') DEFAULT NULL COMMENT 'Column for property value: Action'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\Comm\\Offer_Enforcement_Item';

-- --------------------------------------------------------

--
-- Table structure for table `Orders`
--

CREATE TABLE `Orders` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Channel` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Channel',
  `$Property` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Property',
  `Special_Requests` text DEFAULT NULL COMMENT 'Column for property value: Special_Requests',
  `IP` varchar(255) DEFAULT NULL COMMENT 'Column for property value: IP',
  `Comission` float DEFAULT NULL COMMENT 'Column for property value: Comission',
  `Change_Status_Email_Sent` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Change_Status_Email_Sent',
  `$Beneficiary_Company` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Beneficiary_Company',
  `Invoiced_To_Channel` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Invoiced_To_Channel',
  `Invoiced_To_Property_Owner` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Invoiced_To_Property_Owner',
  `$BNR_Rate` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: BNR_Rate',
  `Remote_Id` varchar(65) DEFAULT NULL COMMENT 'Column for property value: Remote_Id',
  `Reference` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Reference',
  `Date` datetime DEFAULT NULL COMMENT 'Column for property value: Date',
  `Last_Modified_Date` datetime DEFAULT NULL COMMENT 'Column for property value: Last_Modified_Date',
  `$Buyer` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Buyer',
  `$Buyer_Company` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Buyer_Company',
  `Status` enum('Proposal','Submitted','Confirmed','Cancelled','Error') DEFAULT NULL COMMENT 'Column for property value: Status',
  `Status_Change_Date` datetime DEFAULT NULL COMMENT 'Column for property value: Status_Change_Date',
  `Total_Price` float DEFAULT NULL COMMENT 'Column for property value: Total_Price',
  `Currency_Code` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Currency_Code',
  `Notes` text DEFAULT NULL COMMENT 'Column for property value: Notes',
  `$Created_By` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Created_By',
  `$Owner` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Owner',
  `$$App$Orders` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Orders`.`Orders` column role'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\Comm\\Order[]';

-- --------------------------------------------------------

--
-- Table structure for table `Orders_Documents`
--

CREATE TABLE `Orders_Documents` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Orders` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Orders_Documents`.`Documents` column role',
  `$Documents` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Documents'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\Comm\\Order.Documents';

-- --------------------------------------------------------

--
-- Table structure for table `Orders_Emails_Sent`
--

CREATE TABLE `Orders_Emails_Sent` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Orders` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Orders_Emails_Sent`.`Emails_Sent` column role',
  `$Emails_Sent` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Emails_Sent'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\Comm\\Order.Emails_Sent';

-- --------------------------------------------------------

--
-- Table structure for table `Orders_Items`
--

CREATE TABLE `Orders_Items` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Order` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Order',
  `Index` int(11) DEFAULT NULL COMMENT 'Column for property value: Index',
  `Caption` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Caption',
  `$Parent` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Parent',
  `Parent_Index` int(11) DEFAULT NULL COMMENT 'Column for property value: Parent_Index',
  `$Offer` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Offer',
  `Quantity` float DEFAULT NULL COMMENT 'Column for property value: Quantity',
  `Unit_Price` float DEFAULT NULL COMMENT 'Column for property value: Unit_Price',
  `Total_Price` float DEFAULT NULL COMMENT 'Column for property value: Total_Price',
  `Total_No_VAT` float DEFAULT NULL COMMENT 'Column for property value: Total_No_VAT',
  `VAT_Percent` float DEFAULT NULL COMMENT 'Column for property value: VAT_Percent',
  `Total_VAT` float DEFAULT NULL COMMENT 'Column for property value: Total_VAT',
  `Notes` text DEFAULT NULL COMMENT 'Column for property value: Notes',
  `$Config` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Config',
  `$Config$_type` smallint(5) UNSIGNED DEFAULT NULL COMMENT 'type column role for property: Omi\\Comm\\Order_Item.Config(Omi\\Comm\\Order_Item_Config)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\Comm\\Order_Item';

-- --------------------------------------------------------

--
-- Table structure for table `Orders_Reverse_Api_Log`
--

CREATE TABLE `Orders_Reverse_Api_Log` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Orders` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Orders_Reverse_Api_Log`.`Reverse_Api_Log` column role',
  `$Reverse_Api_Log` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Reverse_Api_Log'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\Comm\\Order.Reverse_Api_Log';

-- --------------------------------------------------------

--
-- Table structure for table `Payment_Policies`
--

CREATE TABLE `Payment_Policies` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `Remote_Id` varchar(65) DEFAULT NULL COMMENT 'Column for property value: Remote_Id',
  `Name` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Name',
  `Fee_Mode` enum('per_stay','per_person') DEFAULT NULL COMMENT 'Column for property value: Fee_Mode',
  `Auto_Create_Last_Item` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Auto_Create_Last_Item',
  `$Owner` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Owner',
  `$$App$Payment_Policies` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Payment_Policies`.`Payment_Policies` column role'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Payment_Policy[]';

-- --------------------------------------------------------

--
-- Table structure for table `Payment_Policies_Items`
--

CREATE TABLE `Payment_Policies_Items` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Payment_Policies` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Payment_Policies_Items`.`Items` column role',
  `$Items` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Items'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\TFH\\Payment_Policy.Items';

-- --------------------------------------------------------

--
-- Table structure for table `Payment_Policy_Items`
--

CREATE TABLE `Payment_Policy_Items` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `Item_Order` int(11) DEFAULT NULL COMMENT 'Column for property value: Item_Order',
  `Date_Type` enum('days_before','before_date','reservation_date') DEFAULT NULL COMMENT 'Column for property value: Date_Type',
  `Days_Before_Checkin` int(11) DEFAULT NULL COMMENT 'Column for property value: Days_Before_Checkin',
  `Days_After_Reservation` int(11) DEFAULT NULL COMMENT 'Column for property value: Days_After_Reservation',
  `Before_Date` date DEFAULT NULL COMMENT 'Column for property value: Before_Date',
  `Fee_Type` enum('percent','value','first_night','remaining','first_x_nights') DEFAULT NULL COMMENT 'Column for property value: Fee_Type',
  `First_Nights_Count` int(11) DEFAULT NULL COMMENT 'Column for property value: First_Nights_Count',
  `Fee_Percent` float DEFAULT NULL COMMENT 'Column for property value: Fee_Percent',
  `Fee_Value` int(11) DEFAULT NULL COMMENT 'Column for property value: Fee_Value',
  `Fee_Percent_Nights` float DEFAULT NULL COMMENT 'Column for property value: Fee_Percent_Nights',
  `Minimum_Fee` int(11) DEFAULT NULL COMMENT 'Column for property value: Minimum_Fee'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Payment_Policy_Item';

-- --------------------------------------------------------

--
-- Table structure for table `Persons`
--

CREATE TABLE `Persons` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `Default` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Default',
  `Gender` enum('Male','Female') DEFAULT NULL COMMENT 'Column for property value: Gender',
  `Age` int(11) DEFAULT NULL COMMENT 'Column for property value: Age',
  `Firstname` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Firstname',
  `BirthDate` date DEFAULT NULL COMMENT 'Column for property value: BirthDate',
  `UniqueIdentifier` varchar(255) DEFAULT NULL COMMENT 'Column for property value: UniqueIdentifier',
  `IdentityCardSeries` varchar(255) DEFAULT NULL COMMENT 'Column for property value: IdentityCardSeries',
  `IdentityCardNumber` varchar(255) DEFAULT NULL COMMENT 'Column for property value: IdentityCardNumber',
  `PassportSeries` varchar(255) DEFAULT NULL COMMENT 'Column for property value: PassportSeries',
  `PassportExpireDate` date DEFAULT NULL COMMENT 'Column for property value: PassportExpireDate',
  `Mobile` varchar(32) DEFAULT NULL COMMENT 'Column for property value: Mobile',
  `HomeNumber` varchar(32) DEFAULT NULL COMMENT 'Column for property value: HomeNumber',
  `FaxNumber` varchar(32) DEFAULT NULL COMMENT 'Column for property value: FaxNumber',
  `Title` enum('Mr.','Mrs.','Ms.') DEFAULT NULL COMMENT 'Column for property value: Title',
  `CreateLogin` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: CreateLogin',
  `Name` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Name',
  `Email` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Email',
  `Phone` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Phone',
  `Role` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Role',
  `IsDefault` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: IsDefault',
  `$Address` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Address',
  `$$App$Contacts` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Persons`.`Contacts` column role'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\Person[]';

-- --------------------------------------------------------

--
-- Table structure for table `Price_Profile`
--

CREATE TABLE `Price_Profile` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `Name` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Name',
  `Currency` enum('RON','EUR','USD') DEFAULT NULL COMMENT 'Column for property value: Currency',
  `$Owner` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Owner',
  `$$App$Price_Profiles` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Price_Profile`.`Price_Profiles` column role'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\Comm\\Price_Profile[]';

-- --------------------------------------------------------

--
-- Table structure for table `Price_Profile_Item`
--

CREATE TABLE `Price_Profile_Item` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Offer` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Offer',
  `$TFH_Property` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: TFH_Property',
  `$TFH_Room` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: TFH_Room',
  `$TFH_Rate` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: TFH_Rate',
  `TFH_Mode` enum('included','not_available','priced') DEFAULT NULL COMMENT 'Column for property value: TFH_Mode',
  `$Price_Profile` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Price_Profile_Item`.`Items` column role',
  `Price` float DEFAULT NULL COMMENT 'Column for property value: Price',
  `Active` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\Comm\\Price_Profile_Item[]';

-- --------------------------------------------------------

--
-- Table structure for table `Properties`
--

CREATE TABLE `Properties` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Owner` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Owner',
  `Remote_Id` varchar(65) DEFAULT NULL COMMENT 'Column for property value: Remote_Id',
  `Name` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Name',
  `$Contract` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Contract',
  `Active` tinyint(1) DEFAULT 0 COMMENT 'Column for property value: Active',
  `Active_By_H2B` tinyint(1) DEFAULT 0 COMMENT 'Column for property value: Active_By_H2B',
  `Email` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Email',
  `Requested_Activation_By_H2B` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Requested_Activation_By_H2B',
  `Enable_All_Channels` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Enable_All_Channels',
  `Comission` float DEFAULT NULL COMMENT 'Column for property value: Comission',
  `$Address` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Properties`.`Properties` column role',
  `Child_From_Age` int(11) DEFAULT NULL COMMENT 'Column for property value: Child_From_Age',
  `Adult_From_Age` int(11) DEFAULT NULL COMMENT 'Column for property value: Adult_From_Age',
  `Stars` enum('0','1','2','3','4','5') DEFAULT NULL COMMENT 'Column for property value: Stars',
  `Type` enum('Hotel','ApartHotel','Motel','Villa','Apartment','Holiday Home','Camping','Hostel','Chalet','Bungalow','Guest house','Agro-tourism guest house','Resort','Tourist boarding house','Camping type cottages','River ship','Sea ship','Camping plots','Floating pontoon','Tourist stop') DEFAULT NULL COMMENT 'Column for property value: Type',
  `Content_Description_HTML` text DEFAULT NULL COMMENT 'Column for property value: Content_Description_HTML',
  `Check_In_Time` time DEFAULT NULL COMMENT 'Column for property value: Check_In_Time',
  `Check_In_Time_Hour` int(11) DEFAULT NULL COMMENT 'Column for property value: Check_In_Time_Hour',
  `Check_In_Time_Minutes` int(11) DEFAULT NULL COMMENT 'Column for property value: Check_In_Time_Minutes',
  `Check_Out_Time` time DEFAULT NULL COMMENT 'Column for property value: Check_Out_Time',
  `Check_Out_Time_Hour` int(11) DEFAULT NULL COMMENT 'Column for property value: Check_Out_Time_Hour',
  `Check_Out_Time_Minutes` int(11) DEFAULT NULL COMMENT 'Column for property value: Check_Out_Time_Minutes',
  `Building_Info_Total_Rooms` int(11) DEFAULT NULL COMMENT 'Column for property value: Building_Info_Total_Rooms',
  `Building_Info_Floors_Count` int(11) DEFAULT NULL COMMENT 'Column for property value: Building_Info_Floors_Count',
  `$Content_Image` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Content_Image',
  `$Property_Facil_Top` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Property_Facil_Top',
  `$Property_Facil_Activities` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Property_Facil_Activities',
  `$Property_Facil_Food_Drink` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Property_Facil_Food_Drink',
  `$Property_Facil_Pool_And_Wellness` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Property_Facil_Pool_And_Wellness',
  `$Property_Facil_Transport` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Property_Facil_Transport',
  `$Property_Facil_Reception_Services` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Property_Facil_Reception_Services',
  `$Property_Facil_Common_Areas` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Property_Facil_Common_Areas',
  `$Property_Facil_Entertainment_And_Family_Services` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Property_Facil_Entertainment_And_Family_Services',
  `$Property_Facil_Cleaning_Services` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Property_Facil_Cleaning_Services',
  `$Property_Facil_Business_Facilities` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Property_Facil_Business_Facilities',
  `$Property_Facil_General` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Property_Facil_General',
  `Classification_Certificate` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Classification_Certificate',
  `Classification_Certificate_Number` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Classification_Certificate_Number',
  `Classification_Certificate_Issued_Date` date DEFAULT NULL COMMENT 'Column for property value: Classification_Certificate_Issued_Date',
  `Currency` enum('RON','EUR','USD','BGN') DEFAULT NULL COMMENT 'Column for property value: Currency',
  `API_Managed` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: API_Managed',
  `$API_Managed_User` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: API_Managed_User',
  `$Price_Profile` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Price_Profile',
  `$Logo` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Logo',
  `Static_Map` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Static_Map',
  `D_Edge` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: D_Edge',
  `$Property_Stats` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Property_Stats',
  `Property_Stats_Last_Update` datetime DEFAULT NULL COMMENT 'Column for property value: Property_Stats_Last_Update',
  `Search_CodeGen_MTime` datetime DEFAULT NULL COMMENT 'Column for property value: Search_CodeGen_MTime',
  `Search_CodeGen_LastSync` datetime DEFAULT NULL COMMENT 'Column for property value: Search_CodeGen_LastSync',
  `Search_CodeGen_Status` enum('none','started','done','error') NOT NULL DEFAULT 'none' COMMENT 'Column for property value: Search_CodeGen_Status',
  `Sell_Currency` enum('','EUR','USD','RON','BGN') DEFAULT '' COMMENT 'Column for property value: Sell_Currency',
  `Sell_Currency_Exchange_Tolerance` decimal(5,2) DEFAULT 1.00 COMMENT 'Column for property value: Sell_Currency_Exchange_Tolerance',
  `$$App$Properties` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Properties`.`Properties` column role'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Property[]';

-- --------------------------------------------------------

--
-- Table structure for table `Properties_Access`
--

CREATE TABLE `Properties_Access` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Access` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Properties_Access`.`Can_Access_Properties` column role',
  `$Properties` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Can_Access_Properties'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\User.Can_Access_Properties';

-- --------------------------------------------------------

--
-- Table structure for table `Properties_Age_Intervals`
--

CREATE TABLE `Properties_Age_Intervals` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Properties` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Properties_Age_Intervals`.`Age_Intervals` column role',
  `$none` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Age_Intervals'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\TFH\\Property.Age_Intervals';

-- --------------------------------------------------------

--
-- Table structure for table `Properties_Content_Images`
--

CREATE TABLE `Properties_Content_Images` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Properties` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Properties_Content_Images`.`Content_Images` column role',
  `$Content_Images` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Content_Images'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\TFH\\Property.Content_Images';

-- --------------------------------------------------------

--
-- Table structure for table `Properties_Content_Video_Embeds`
--

CREATE TABLE `Properties_Content_Video_Embeds` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Properties` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Properties_Content_Video_Embeds`.`Content_Video_Embeds` column role',
  `$Content_Video_Embeds` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Content_Video_Embeds'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\TFH\\Property.Content_Video_Embeds';

-- --------------------------------------------------------

--
-- Table structure for table `Properties_Languages_Spoken`
--

CREATE TABLE `Properties_Languages_Spoken` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Properties` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Properties_Languages_Spoken`.`Languages_Spoken` column role',
  `$Languages_Spoken` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Languages_Spoken'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\TFH\\Property.Languages_Spoken';

-- --------------------------------------------------------

--
-- Table structure for table `Properties_Rooms`
--

CREATE TABLE `Properties_Rooms` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Property` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Property',
  `Remote_Id` varchar(65) DEFAULT NULL COMMENT 'Column for property value: Remote_Id',
  `Name` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Name',
  `Index` int(11) DEFAULT NULL COMMENT 'Column for property value: Index',
  `Standard_Type` enum('Single','Double','Twin','Twin/Double','Triple','Quadruple','Family','Studio','Apartment','Dormitory room','Bed in Dormitory','Bungalow','Chalet','Villa','Holiday home','Mobile home','Tent') DEFAULT NULL COMMENT 'Column for property value: Standard_Type',
  `Size` float DEFAULT NULL COMMENT 'Column for property value: Size',
  `$Occupancy` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Properties_Rooms`.`Rooms` column role',
  `Count` int(11) DEFAULT NULL COMMENT 'Column for property value: Count',
  `$Property_Room_Facil_Top` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Property_Room_Facil_Top',
  `$Property_Room_Facil_Other` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Property_Room_Facil_Other',
  `Content_Description_HTML` text DEFAULT NULL COMMENT 'Column for property value: Content_Description_HTML',
  `Bathroom_Count` int(11) DEFAULT NULL COMMENT 'Column for property value: Bathroom_Count',
  `Bathroom_Private` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Bathroom_Private',
  `Bathroom_In_Room` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Bathroom_In_Room',
  `$Extra_Beds_Limits` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Extra_Beds_Limits',
  `Smoking_Policy` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Smoking_Policy',
  `Room_Location` enum('None','Ground Floor','Upper Floor') DEFAULT NULL COMMENT 'Column for property value: Room_Location',
  `$Occupancy_Enforcement` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Occupancy_Enforcement',
  `$Beds_Enforcement` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Beds_Enforcement',
  `$Special_Deal` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Special_Deal',
  `$App_Properties_Rooms` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Properties_Rooms`.`Properties_Rooms` column role',
  `$Room_Availability_Stats` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Room_Availability_Stats',
  `Room_Availability_Stats_Last_Update` datetime DEFAULT NULL COMMENT 'Column for property value: Room_Availability_Stats_Last_Update'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Property_Room[]';

-- --------------------------------------------------------

--
-- Table structure for table `Properties_Rooms_Beds`
--

CREATE TABLE `Properties_Rooms_Beds` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `Bed_Type` enum('Single bed','Double Bed','Large bed (King size bed)','Extra large bed','Bunk bed','Sofa bed','Extendable sofa','Extendable armchair') DEFAULT NULL COMMENT 'Column for property value: Bed_Type',
  `Number_Of_Beds` int(11) DEFAULT NULL COMMENT 'Column for property value: Number_Of_Beds',
  `Add_Alternative_Bed` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Add_Alternative_Bed',
  `Alternative_Bed_Type` enum('Single bed','Double Bed','Large bed (King size bed)','Extra large bed','Bunk bed','Sofa bed','Extendable sofa','Extendable armchair') DEFAULT NULL COMMENT 'Column for property value: Alternative_Bed_Type',
  `Alternative_Number_Of_Beds` int(11) DEFAULT NULL COMMENT 'Column for property value: Alternative_Number_Of_Beds'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Property_Room_Beds';

-- --------------------------------------------------------

--
-- Table structure for table `Properties_Rooms_Content_Images`
--

CREATE TABLE `Properties_Rooms_Content_Images` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Properties_Rooms` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Properties_Rooms_Content_Images`.`Content_Images` column role',
  `$Content_Images` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Content_Images'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\TFH\\Property_Room.Content_Images';

-- --------------------------------------------------------

--
-- Table structure for table `Properties_Rooms_Content_Video_Embeds`
--

CREATE TABLE `Properties_Rooms_Content_Video_Embeds` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Properties_Rooms` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Properties_Rooms_Content_Video_Embeds`.`Content_Video_Embeds` column role',
  `$Content_Video_Embeds` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Content_Video_Embeds'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\TFH\\Property_Room.Content_Video_Embeds';

-- --------------------------------------------------------

--
-- Table structure for table `Properties_Rooms_Extra_Beds_Limits_Per_Room`
--

CREATE TABLE `Properties_Rooms_Extra_Beds_Limits_Per_Room` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Properties_Rooms` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Properties_Rooms_Extra_Beds_Limits_Per_Room`.`Extra_Beds_Limits_Per_Room` column role',
  `$Extra_Beds_Limits_Per_Room` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Extra_Beds_Limits_Per_Room'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\TFH\\Property_Room.Extra_Beds_Limits_Per_Room';

-- --------------------------------------------------------

--
-- Table structure for table `Properties_Rooms_Property_Room_Beds`
--

CREATE TABLE `Properties_Rooms_Property_Room_Beds` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Properties_Rooms` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Properties_Rooms_Property_Room_Beds`.`Property_Room_Beds` column role',
  `$Property_Room_Beds` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Property_Room_Beds'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\TFH\\Property_Room.Property_Room_Beds';

-- --------------------------------------------------------

--
-- Table structure for table `Properties_Services`
--

CREATE TABLE `Properties_Services` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Properties` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Properties_Services`.`Services` column role',
  `$none` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Services'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\TFH\\Property.Services';

-- --------------------------------------------------------

--
-- Table structure for table `Properties_Stats`
--

CREATE TABLE `Properties_Stats` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `Count_Live_Rates` int(11) DEFAULT NULL COMMENT 'Column for property value: Count_Live_Rates',
  `Has_Age_Intervals` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Has_Age_Intervals'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Property_Stats';

-- --------------------------------------------------------

--
-- Table structure for table `Properties_Store_Locations`
--

CREATE TABLE `Properties_Store_Locations` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Property` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Property',
  `$Store_Location` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Store_Location',
  `Index` int(11) DEFAULT NULL COMMENT 'Column for property value: Index'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Property_Store_Location';

-- --------------------------------------------------------

--
-- Table structure for table `Property_Contracts`
--

CREATE TABLE `Property_Contracts` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `File` varchar(255) DEFAULT NULL COMMENT 'Column for property value: File',
  `Contract_Upload_Date` datetime DEFAULT NULL COMMENT 'Column for property value: Contract_Upload_Date',
  `Contract_Upload_IP` varchar(32) DEFAULT NULL COMMENT 'Column for property value: Contract_Upload_IP',
  `$Contract_Upload_User` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Contract_Upload_User',
  `Agreement_Type` enum('required_signed_contract','contract_terms_acceptance') DEFAULT NULL COMMENT 'Column for property value: Agreement_Type',
  `Contract_Presigned` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Contract_Presigned'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Property_Contract';

-- --------------------------------------------------------

--
-- Table structure for table `Property_Facil_Activities`
--

CREATE TABLE `Property_Facil_Activities` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `Tennis_Equipment` enum('no','free','paid') DEFAULT NULL COMMENT 'Column for property value: Tennis_Equipment',
  `Badminton_Equipment` enum('no','free','paid') DEFAULT NULL COMMENT 'Column for property value: Badminton_Equipment',
  `Beach` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Beach',
  `Billiards` enum('no','free','paid') DEFAULT NULL COMMENT 'Column for property value: Billiards',
  `Table_Tennis` enum('no','free','paid') DEFAULT NULL COMMENT 'Column for property value: Table_Tennis',
  `Darts` enum('no','free','paid') DEFAULT NULL COMMENT 'Column for property value: Darts',
  `Squash` enum('no','free','paid') DEFAULT NULL COMMENT 'Column for property value: Squash',
  `Bowling` enum('no','free','paid') DEFAULT NULL COMMENT 'Column for property value: Bowling',
  `Mini_Golf` enum('no','free','paid') DEFAULT NULL COMMENT 'Column for property value: Mini_Golf',
  `Golf_Course` enum('no','free','paid') DEFAULT NULL COMMENT 'Column for property value: Golf_Course',
  `Water_Park` enum('no','free','paid') DEFAULT NULL COMMENT 'Column for property value: Water_Park',
  `Water_Sport_Facilities` enum('no','free','paid') DEFAULT NULL COMMENT 'Column for property value: Water_Sport_Facilities',
  `Windsurfing` enum('no','free','paid') DEFAULT NULL COMMENT 'Column for property value: Windsurfing',
  `Diving` enum('no','free','paid') DEFAULT NULL COMMENT 'Column for property value: Diving',
  `Snorkelling` enum('no','free','paid') DEFAULT NULL COMMENT 'Column for property value: Snorkelling',
  `Canoeing` enum('no','free','paid') DEFAULT NULL COMMENT 'Column for property value: Canoeing',
  `Fishing` enum('no','free','paid') DEFAULT NULL COMMENT 'Column for property value: Fishing',
  `Horse_Riding` enum('no','free','paid') DEFAULT NULL COMMENT 'Column for property value: Horse_Riding',
  `Cycling` enum('no','free','paid') DEFAULT NULL COMMENT 'Column for property value: Cycling',
  `Hiking` enum('no','free','paid') DEFAULT NULL COMMENT 'Column for property value: Hiking',
  `Skiing` enum('no','free','paid') DEFAULT NULL COMMENT 'Column for property value: Skiing',
  `Archery` enum('no','free','paid') DEFAULT NULL COMMENT 'Column for property value: Archery',
  `Aerobics` enum('no','free','paid') DEFAULT NULL COMMENT 'Column for property value: Aerobics',
  `Tennis_Court` enum('no','free','paid') DEFAULT NULL COMMENT 'Column for property value: Tennis_Court'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Property_Facil_Activities';

-- --------------------------------------------------------

--
-- Table structure for table `Property_Facil_Business_Facilities`
--

CREATE TABLE `Property_Facil_Business_Facilities` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `Meeting_Banquet_Facilities` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Meeting_Banquet_Facilities',
  `Business_Centre` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Business_Centre'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Property_Facil_Business_Facilities';

-- --------------------------------------------------------

--
-- Table structure for table `Property_Facil_Cleaning_Services`
--

CREATE TABLE `Property_Facil_Cleaning_Services` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `Dry_Cleaning` enum('no','free','paid') DEFAULT NULL COMMENT 'Column for property value: Dry_Cleaning',
  `Ironing_Service` enum('no','free','paid') DEFAULT NULL COMMENT 'Column for property value: Ironing_Service',
  `Laundry` enum('no','free','paid') DEFAULT NULL COMMENT 'Column for property value: Laundry',
  `Daily_Housekeeping` enum('no','free','paid') DEFAULT NULL COMMENT 'Column for property value: Daily_Housekeeping',
  `Shoeshine` enum('no','free','paid') DEFAULT NULL COMMENT 'Column for property value: Shoeshine',
  `Trouser_Press` enum('no','free','paid') DEFAULT NULL COMMENT 'Column for property value: Trouser_Press'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Property_Facil_Cleaning_Services';

-- --------------------------------------------------------

--
-- Table structure for table `Property_Facil_Common_Areas`
--

CREATE TABLE `Property_Facil_Common_Areas` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `Outdoor_Furniture` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Outdoor_Furniture',
  `Outdoor_Fireplace` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Outdoor_Fireplace',
  `Indoor_Fireplace` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Indoor_Fireplace',
  `Picnic_Area` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Picnic_Area',
  `Sun_Terrace` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Sun_Terrace',
  `Shared_Kitchen` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Shared_Kitchen',
  `Shared_Lounge_TV_Area` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Shared_Lounge_TV_Area',
  `Games_Room` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Games_Room',
  `Library` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Library'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Property_Facil_Common_Areas';

-- --------------------------------------------------------

--
-- Table structure for table `Property_Facil_Entertainment_And_Family_Services`
--

CREATE TABLE `Property_Facil_Entertainment_And_Family_Services` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `Board_Games_Puzzles` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Board_Games_Puzzles',
  `Books_DVDs_Music_for_Children` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Books_DVDs_Music_for_Children',
  `Indoor_Play_Area` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Indoor_Play_Area',
  `Children_Television_Networks` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Children_Television_Networks',
  `Kids_Outdoor_Play_Equipment` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Kids_Outdoor_Play_Equipment',
  `Baby_Safety_Gates` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Baby_Safety_Gates',
  `Strollers` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Strollers',
  `Evening_Entertainment` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Evening_Entertainment',
  `Nightclub_DJ` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Nightclub_DJ',
  `Casino` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Casino',
  `Karaoke` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Karaoke',
  `Entertainment_Staff` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Entertainment_Staff',
  `Kids_Club` enum('no','free','paid') DEFAULT NULL COMMENT 'Column for property value: Kids_Club',
  `Childrens_Playground` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Childrens_Playground',
  `Babysitting_Child_Services` enum('no','free','paid') DEFAULT NULL COMMENT 'Column for property value: Babysitting_Child_Services'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Property_Facil_Entertainment_And_Family_Services';

-- --------------------------------------------------------

--
-- Table structure for table `Property_Facil_Food_Drink`
--

CREATE TABLE `Property_Facil_Food_Drink` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `Kid_Meals` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Kid_Meals',
  `Kid_friendly_Buffet` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Kid_friendly_Buffet',
  `On_site_Coffee_House` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: On_site_Coffee_House',
  `Restaurant` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Restaurant',
  `Snack_Bar` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Snack_Bar',
  `BBQ_Facilities` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: BBQ_Facilities',
  `Special_Diet_Menus` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Special_Diet_Menus',
  `Room_Service` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Room_Service',
  `Breakfast_In_The_Room` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Breakfast_In_The_Room'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Property_Facil_Food_Drink';

-- --------------------------------------------------------

--
-- Table structure for table `Property_Facil_General`
--

CREATE TABLE `Property_Facil_General` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `Designated_Smoking_Area` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Designated_Smoking_Area',
  `Non_Smoking_Throughout` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Non_Smoking_Throughout',
  `Allergy_Free_Room` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Allergy_Free_Room',
  `Adult_Only` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Adult_Only',
  `Key_Access` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Key_Access',
  `Key_Card_Access` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Key_Card_Access',
  `Digital_Key_Access` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Digital_Key_Access',
  `Facilities_For_Disabled_Guests` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Facilities_For_Disabled_Guests',
  `Soundproof_Rooms` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Soundproof_Rooms',
  `Lift` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Lift',
  `VIP_Room_Facilities` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: VIP_Room_Facilities',
  `Facil_24_Hour_Security` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Facil_24_Hour_Security',
  `CCTV_in_Common_Areas` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: CCTV_in_Common_Areas',
  `CCTV_Outside_Property` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: CCTV_Outside_Property',
  `Security_Alarm` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Security_Alarm',
  `Smoke_Alarms` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Smoke_Alarms'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Property_Facil_General';

-- --------------------------------------------------------

--
-- Table structure for table `Property_Facil_Pool_And_Wellness`
--

CREATE TABLE `Property_Facil_Pool_And_Wellness` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `Water_Slide` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Water_Slide',
  `Pool_Beach_Towels` enum('no','free','paid') DEFAULT NULL COMMENT 'Column for property value: Pool_Beach_Towels',
  `Sun_Loungers_or_Beach_Chairs` enum('no','free','paid') DEFAULT NULL COMMENT 'Column for property value: Sun_Loungers_or_Beach_Chairs',
  `Sun_Umbrellas` enum('no','free','paid') DEFAULT NULL COMMENT 'Column for property value: Sun_Umbrellas',
  `Beauty_Services` enum('no','free','paid') DEFAULT NULL COMMENT 'Column for property value: Beauty_Services',
  `Spa_Facilities` enum('no','free','paid') DEFAULT NULL COMMENT 'Column for property value: Spa_Facilities',
  `Spa_Lounge_Relaxation_Area` enum('no','free','paid') DEFAULT NULL COMMENT 'Column for property value: Spa_Lounge_Relaxation_Area',
  `Spa_Wellness_Packages` enum('no','free','paid') DEFAULT NULL COMMENT 'Column for property value: Spa_Wellness_Packages',
  `Spa_and_Wellness_Centre` enum('no','free','paid') DEFAULT NULL COMMENT 'Column for property value: Spa_and_Wellness_Centre',
  `Fitness` enum('no','free','paid') DEFAULT NULL COMMENT 'Column for property value: Fitness',
  `Fitness_Classes` enum('no','free','paid') DEFAULT NULL COMMENT 'Column for property value: Fitness_Classes',
  `Personal_Trainer` enum('no','free','paid') DEFAULT NULL COMMENT 'Column for property value: Personal_Trainer',
  `Yoga_Classes` enum('no','free','paid') DEFAULT NULL COMMENT 'Column for property value: Yoga_Classes',
  `Kids_Pool` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Kids_Pool',
  `Massage` enum('no','free','paid') DEFAULT NULL COMMENT 'Column for property value: Massage',
  `Tub` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Tub'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Property_Facil_Pool_And_Wellness';

-- --------------------------------------------------------

--
-- Table structure for table `Property_Facil_Reception_Services`
--

CREATE TABLE `Property_Facil_Reception_Services` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `Concierge_Service` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Concierge_Service',
  `Facil_24_Hour_Front_Desk` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Facil_24_Hour_Front_Desk',
  `Private_Check_in_Check_out` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Private_Check_in_Check_out',
  `Express_Check_in_Check_out` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Express_Check_in_Check_out',
  `Tour_Desk` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Tour_Desk',
  `Currency_Exchange` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Currency_Exchange',
  `ATM_Cash_Machine_on_Site` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: ATM_Cash_Machine_on_Site',
  `Luggage_Storage` enum('no','free','paid') DEFAULT NULL COMMENT 'Column for property value: Luggage_Storage',
  `Safety_Deposit_Box` enum('no','free','paid') DEFAULT NULL COMMENT 'Column for property value: Safety_Deposit_Box'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Property_Facil_Reception_Services';

-- --------------------------------------------------------

--
-- Table structure for table `Property_Facil_Top`
--

CREATE TABLE `Property_Facil_Top` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `Swimming_Pool` enum('no','free','paid') DEFAULT NULL COMMENT 'Column for property value: Swimming_Pool',
  `Air_Conditioning` enum('no','free','paid') DEFAULT NULL COMMENT 'Column for property value: Air_Conditioning',
  `Non_Smoking_Rooms` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Non_Smoking_Rooms',
  `Sauna` enum('no','free','paid') DEFAULT NULL COMMENT 'Column for property value: Sauna',
  `Hot_tub_jacuzzi` enum('no','free','paid') DEFAULT NULL COMMENT 'Column for property value: Hot_tub_jacuzzi',
  `Terrace` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Terrace',
  `Bar` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Bar',
  `Restaurant` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Restaurant',
  `Garden` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Garden',
  `WiFi` enum('no','free','paid') DEFAULT NULL COMMENT 'Column for property value: WiFi',
  `Outdoor_Pool` enum('no','free','paid') DEFAULT NULL COMMENT 'Column for property value: Outdoor_Pool',
  `Indoor_Pool` enum('no','free','paid') DEFAULT NULL COMMENT 'Column for property value: Indoor_Pool',
  `Parking` enum('no','free','paid') DEFAULT NULL COMMENT 'Column for property value: Parking',
  `Pet_Friendly` enum('no','free','paid') DEFAULT NULL COMMENT 'Column for property value: Pet_Friendly',
  `Self_CheckIn` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Self_CheckIn'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Property_Facil_Top';

-- --------------------------------------------------------

--
-- Table structure for table `Property_Facil_Transport`
--

CREATE TABLE `Property_Facil_Transport` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `Secured_Parking` enum('no','free','paid') DEFAULT NULL COMMENT 'Column for property value: Secured_Parking',
  `Street_Parking` enum('no','free','paid') DEFAULT NULL COMMENT 'Column for property value: Street_Parking',
  `Parking_Garage` enum('no','free','paid') DEFAULT NULL COMMENT 'Column for property value: Parking_Garage',
  `Valet_Parking` enum('no','free','paid') DEFAULT NULL COMMENT 'Column for property value: Valet_Parking',
  `Airport_Shuttle` enum('no','free','paid') DEFAULT NULL COMMENT 'Column for property value: Airport_Shuttle',
  `Car_Hire` enum('no','free','paid') DEFAULT NULL COMMENT 'Column for property value: Car_Hire'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Property_Facil_Transport';

-- --------------------------------------------------------

--
-- Table structure for table `Property_Rooms_Availability_Stats`
--

CREATE TABLE `Property_Rooms_Availability_Stats` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `Has_One_Year_Prices` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Has_One_Year_Prices'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Property_Room_Availability_Stats';

-- --------------------------------------------------------

--
-- Table structure for table `Property_Rooms_Availability_Stats_Has_Prices_Interval`
--

CREATE TABLE `Property_Rooms_Availability_Stats_Has_Prices_Interval` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Property_Rooms_Availability_Stats` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Property_Rooms_Availability_Stats_Has_Prices_Interval`.`Has_Prices_Interval` column role',
  `Has_Prices_Interval` date DEFAULT NULL COMMENT 'Column for property value: Has_Prices_Interval'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\TFH\\Property_Room_Availability_Stats.Has_Prices_Interval';

-- --------------------------------------------------------

--
-- Table structure for table `Property_Rooms_Availability_Stats_No_Prices_Interval`
--

CREATE TABLE `Property_Rooms_Availability_Stats_No_Prices_Interval` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Property_Rooms_Availability_Stats` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Property_Rooms_Availability_Stats_No_Prices_Interval`.`No_Prices_Interval` column role',
  `$No_Prices_Interval` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: No_Prices_Interval'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\TFH\\Property_Room_Availability_Stats.No_Prices_Interval';

-- --------------------------------------------------------

--
-- Table structure for table `Property_Room_Facil_Other`
--

CREATE TABLE `Property_Room_Facil_Other` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `Free_Toiletries` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Free_Toiletries',
  `Safe_Box` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Safe_Box',
  `Toilet` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Toilet',
  `Bath_or_Shower` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Bath_or_Shower',
  `Towels` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Towels',
  `Bathrobe` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Bathrobe',
  `Slippers` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Slippers',
  `Bed_Sheets` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Bed_Sheets',
  `Socket_by_the_Bed` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Socket_by_the_Bed',
  `Office_Desk` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Office_Desk',
  `TV` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: TV',
  `Phone` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Phone',
  `Ironing_Facilities` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Ironing_Facilities',
  `Satellite_Channels` enum('no','free','paid') DEFAULT NULL COMMENT 'Column for property value: Satellite_Channels',
  `Tea_Coffee_Maker` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Tea_Coffee_Maker',
  `Iron` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Iron',
  `Pay_Channels` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Pay_Channels',
  `Heating` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Heating',
  `Hairdryer` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Hairdryer',
  `Fan` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Fan',
  `Kettle_Cup` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Kettle_Cup',
  `Cable_Channels` enum('no','free','paid') DEFAULT NULL COMMENT 'Column for property value: Cable_Channels',
  `Wake_up_Service` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Wake_up_Service',
  `Wardrobe_or_Closet` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Wardrobe_or_Closet',
  `Upper_Floors_Accessible_by_Elevator` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Upper_Floors_Accessible_by_Elevator',
  `Clothes_Holder` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Clothes_Holder',
  `Toilet_Paper` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Toilet_Paper',
  `Hand_Sanitizer` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Hand_Sanitizer',
  `Air_Conditioning` enum('no','free','paid') DEFAULT NULL COMMENT 'Column for property value: Air_Conditioning',
  `Radio` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Radio',
  `Microwave_Oven` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Microwave_Oven',
  `Kitchen_Utensils` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Kitchen_Utensils',
  `Kitchenette` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Kitchenette',
  `IPod_Dock` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: IPod_Dock',
  `Relaxation_Area` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Relaxation_Area'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Property_Room_Facil_Other';

-- --------------------------------------------------------

--
-- Table structure for table `Property_Room_Facil_Top`
--

CREATE TABLE `Property_Room_Facil_Top` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `Air_Conditioning` enum('no','free','paid') DEFAULT NULL COMMENT 'Column for property value: Air_Conditioning',
  `Balcony` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Balcony',
  `Bath` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Bath',
  `View` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: View',
  `Flat_Screen_TV` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Flat_Screen_TV',
  `Electric_Kettle` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Electric_Kettle',
  `Soundproofing` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Soundproofing',
  `Toilet_Paper` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Toilet_Paper',
  `Towels` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Towels',
  `WiFi` enum('no','free','paid') DEFAULT NULL COMMENT 'Column for property value: WiFi',
  `Mini_Bar` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Mini_Bar',
  `Mini_Fridge` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Mini_Fridge'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Property_Room_Facil_Top';

-- --------------------------------------------------------

--
-- Table structure for table `Rate_Plans`
--

CREATE TABLE `Rate_Plans` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `Remote_Id` varchar(65) DEFAULT NULL COMMENT 'Column for property value: Remote_Id',
  `Name` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Name',
  `Meal_Option` enum('none','breakfast','half_board','full_board','all_inclusive') DEFAULT NULL COMMENT 'Column for property value: Meal_Option',
  `$Meal_Service` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Meal_Service',
  `$Occupancy` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Occupancy',
  `$Restrictions` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Restrictions',
  `$Cancellation_Policy` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Cancellation_Policy',
  `$Payment_Policy` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Payment_Policy',
  `Active` tinyint(1) DEFAULT 0 COMMENT 'Column for property value: Active',
  `Currency` enum('','RON','EUR','USD') DEFAULT NULL COMMENT 'Column for property value: Currency',
  `Pricing_Mode` enum('h2b','per_room','per_person','per_occupancy') DEFAULT 'h2b' COMMENT 'Column for property value: Pricing_Mode',
  `$Owner` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Owner',
  `$Special_Deals$TFH_Rate_Plans` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Rate_Plans`.`TFH_Rate_Plans` column role',
  `$$App$Rate_Plans` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Rate_Plans`.`Rate_Plans` column role'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Rate_Plan[]';

-- --------------------------------------------------------

--
-- Table structure for table `Rate_Plans_Extra_Services`
--

CREATE TABLE `Rate_Plans_Extra_Services` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Rate_Plans` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Rate_Plans_Extra_Services`.`Extra_Services` column role',
  `$Extra_Services` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Extra_Services'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\TFH\\Rate_Plan.Extra_Services';

-- --------------------------------------------------------

--
-- Table structure for table `Rate_Plan_Access`
--

CREATE TABLE `Rate_Plan_Access` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Rate` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Rate',
  `$Property` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Property',
  `$Channel` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Channel',
  `Enabled` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Enabled',
  `Enable_All_Channels` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Enable_All_Channels'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Rate_Plan_Access';

-- --------------------------------------------------------

--
-- Table structure for table `Rate_Plan_Extra_Service`
--

CREATE TABLE `Rate_Plan_Extra_Service` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `Remote_Id` varchar(65) DEFAULT NULL COMMENT 'Column for property value: Remote_Id',
  `$Offer` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Offer',
  `Quantity` int(11) DEFAULT NULL COMMENT 'Column for property value: Quantity'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Rate_Plan_Extra_Service';

-- --------------------------------------------------------

--
-- Table structure for table `Rate_Plan_Room`
--

CREATE TABLE `Rate_Plan_Room` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Rate_Plan` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Rate_Plans',
  `$Room` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Rate_Plan_Room`.`Rate_Plans` column role',
  `Index` int(11) DEFAULT NULL COMMENT 'Column for property value: Index'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\TFH\\Property_Room.Rate_Plans';

-- --------------------------------------------------------

--
-- Table structure for table `Rate_Set_Requests`
--

CREATE TABLE `Rate_Set_Requests` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$$App$Rate_Set_Requests` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Rate_Set_Requests`.`Rate_Set_Requests` column role',
  `$Room` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Room',
  `$Rate_Plan` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Rate_Plan',
  `Date_Start` date DEFAULT NULL COMMENT 'Column for property value: Date_Start',
  `Date_End` date DEFAULT NULL COMMENT 'Column for property value: Date_End',
  `Weekdays` set('Mon','Tue','Wed','Thu','Fri','Sat','Sun') DEFAULT NULL COMMENT 'Column for property value: Weekdays',
  `Weekday_Mon` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Weekday_Mon',
  `Weekday_Tue` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Weekday_Tue',
  `Weekday_Wed` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Weekday_Wed',
  `Weekday_Thu` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Weekday_Thu',
  `Weekday_Fri` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Weekday_Fri',
  `Weekday_Sat` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Weekday_Sat',
  `Weekday_Sun` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Weekday_Sun',
  `Price` float DEFAULT NULL COMMENT 'Column for property value: Price',
  `Rooms_Count` int(11) DEFAULT NULL COMMENT 'Column for property value: Rooms_Count',
  `Rooms_Status` enum('nochange','open','closed','cancel') DEFAULT NULL COMMENT 'Column for property value: Rooms_Status',
  `Rate_Status` enum('nochange','open','closed','cancel') DEFAULT NULL COMMENT 'Column for property value: Rate_Status',
  `$Restrictions` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Restrictions',
  `$Season` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Season',
  `Do_Delete` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Do_Delete'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Rate_Set_Request';

-- --------------------------------------------------------

--
-- Table structure for table `Registration_Requests`
--

CREATE TABLE `Registration_Requests` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$$App$Registration_Requests` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Registration_Requests`.`Registration_Requests` column role',
  `$Company` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Company',
  `$User` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: User',
  `IP` varchar(32) DEFAULT NULL COMMENT 'Column for property value: IP',
  `Date` datetime DEFAULT NULL COMMENT 'Column for property value: Date'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\Comm\\Registration_Request';

-- --------------------------------------------------------

--
-- Table structure for table `Request_Logs`
--

CREATE TABLE `Request_Logs` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `Date` datetime DEFAULT NULL COMMENT 'Column for property value: Date',
  `Timestamp_ms` decimal(20,4) DEFAULT NULL COMMENT 'Column for property value: Timestamp_ms',
  `Timestamp_ms_end` decimal(20,4) DEFAULT NULL COMMENT 'Column for property value: Timestamp_ms_end',
  `Duration` float DEFAULT NULL COMMENT 'Column for property value: Duration',
  `Is_Error` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Is_Error',
  `Method` char(8) DEFAULT NULL COMMENT 'Column for property value: Method',
  `IP_v4` char(16) DEFAULT NULL COMMENT 'Column for property value: IP_v4',
  `Is_Ajax` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Is_Ajax',
  `Is_Fast_Call` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Is_Fast_Call',
  `Request_URI` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Request_URI',
  `Cookies` text DEFAULT NULL COMMENT 'Column for property value: Cookies',
  `Session_Id` varchar(32) DEFAULT NULL COMMENT 'Column for property value: Session_Id',
  `User_Agent` varchar(1024) DEFAULT NULL COMMENT 'Column for property value: User_Agent',
  `HTTP_GET` text DEFAULT NULL COMMENT 'Column for property value: HTTP_GET',
  `HTTP_POST` mediumtext DEFAULT NULL COMMENT 'Column for property value: HTTP_POST',
  `HTTP_FILES` text DEFAULT NULL COMMENT 'Column for property value: HTTP_FILES',
  `Tags` text DEFAULT NULL COMMENT 'Column for property value: Tags',
  `Traces` longtext DEFAULT NULL COMMENT 'Column for property value: Traces',
  `$$App$Request_Logs` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Request_Logs`.`Request_Logs` column role'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\Request_Log[]';

-- --------------------------------------------------------

--
-- Table structure for table `Request_Logs_Traces`
--

CREATE TABLE `Request_Logs_Traces` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Request` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Request',
  `Index` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Index',
  `Timestamp_ms` decimal(20,4) DEFAULT NULL COMMENT 'Column for property value: Timestamp_ms',
  `Timestamp_ms_end` decimal(20,4) DEFAULT NULL COMMENT 'Column for property value: Timestamp_ms_end',
  `Is_Error` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Is_Error',
  `Tags` varchar(4096) DEFAULT NULL COMMENT 'Column for property value: Tags',
  `Traces` mediumtext DEFAULT NULL COMMENT 'Column for property value: Traces',
  `Data` longtext DEFAULT NULL COMMENT 'Column for property value: Data'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\Request_Log_Trace';

-- --------------------------------------------------------

--
-- Table structure for table `Restrictions`
--

CREATE TABLE `Restrictions` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `Name` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Name',
  `Check_In_Locked` int(11) DEFAULT NULL COMMENT 'Column for property value: Check_In_Locked',
  `Check_Out_Locked` int(11) DEFAULT NULL COMMENT 'Column for property value: Check_Out_Locked',
  `Min_Length_Of_Stay` int(11) DEFAULT NULL COMMENT 'Column for property value: Min_Length_Of_Stay',
  `Min_Relative_Length_Of_Stay` int(11) DEFAULT NULL COMMENT 'Column for property value: Min_Relative_Length_Of_Stay',
  `Min_Length_Of_Stay_From_Arrival` int(11) DEFAULT NULL COMMENT 'Column for property value: Min_Length_Of_Stay_From_Arrival',
  `Max_Length_Of_Stay_From_Arrival` int(11) DEFAULT NULL COMMENT 'Column for property value: Max_Length_Of_Stay_From_Arrival',
  `Min_Advance_Reservation` int(11) DEFAULT NULL COMMENT 'Column for property value: Min_Advance_Reservation',
  `Max_Advance_Reservation` int(11) DEFAULT NULL COMMENT 'Column for property value: Max_Advance_Reservation',
  `$Owner` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Owner',
  `$$App$Restrictions` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Restrictions`.`Restrictions` column role'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Restrictions[]';

-- --------------------------------------------------------

--
-- Table structure for table `Reverse_APIs`
--

CREATE TABLE `Reverse_APIs` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$_type` smallint(5) UNSIGNED DEFAULT NULL COMMENT 'Type column for table entry role',
  `On_Action` varchar(255) DEFAULT NULL COMMENT 'Column for property value: On_Action',
  `URL` varchar(255) DEFAULT NULL COMMENT 'Column for property value: URL',
  `Arguments_Selector` text DEFAULT NULL COMMENT 'Column for property value: Arguments_Selector'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\Reverse_APIs_Item';

-- --------------------------------------------------------

--
-- Table structure for table `Reverse_APIs_Items`
--

CREATE TABLE `Reverse_APIs_Items` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Reverse_APIs` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Reverse_APIs_Items`.`Items` column role',
  `$Items` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Items'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\Reverse_APIs.Items';

-- --------------------------------------------------------

--
-- Table structure for table `Rooms_Occupancy_Beds_Setup`
--

CREATE TABLE `Rooms_Occupancy_Beds_Setup` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Occupancy` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Occupancy',
  `Index` smallint(6) DEFAULT NULL COMMENT 'Column for property value: Index',
  `Tag` varchar(64) DEFAULT NULL COMMENT 'Column for property value: Tag',
  `Type` enum('no_bed','regular_bed','extra_bed') DEFAULT NULL COMMENT 'Column for property value: Type',
  `Seats` smallint(6) DEFAULT NULL COMMENT 'Column for property value: Seats'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Beds_Setup';

-- --------------------------------------------------------

--
-- Table structure for table `Rooms_Occupancy_Beds_Setup_Age_Intervals`
--

CREATE TABLE `Rooms_Occupancy_Beds_Setup_Age_Intervals` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Rooms_Occupancy_Beds_Setup` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Rooms_Occupancy_Beds_Setup_Age_Intervals`.`Age_Intervals` column role',
  `Age_Intervals` enum('infant','toddler','child','adolescent','adult') DEFAULT NULL COMMENT 'Column for property value: Age_Intervals'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\TFH\\Beds_Setup.Age_Intervals';

-- --------------------------------------------------------

--
-- Table structure for table `Room_Occupancies`
--

CREATE TABLE `Room_Occupancies` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `Remote_Id` varchar(65) DEFAULT NULL COMMENT 'Column for property value: Remote_Id',
  `Name` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Name',
  `$Infant_Limits` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Infant_Limits',
  `$Toddler_Limits` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Toddler_Limits',
  `$Child_Limits` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Child_Limits',
  `$Adolescent_Limits` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Adolescent_Limits',
  `$Adult_Limits` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Adult_Limits',
  `Persons_Max` int(11) DEFAULT NULL COMMENT 'Column for property value: Persons_Max',
  `$Owner` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Owner',
  `$$App$Room_Occupancies` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Room_Occupancies`.`Room_Occupancies` column role'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Room_Occupancy[]';

-- --------------------------------------------------------

--
-- Table structure for table `Room_Occupancies_Occupancy_Pricing`
--

CREATE TABLE `Room_Occupancies_Occupancy_Pricing` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Room_Occupancies` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Room_Occupancies_Occupancy_Pricing`.`Occupancy_Pricing` column role',
  `$Occupancy_Pricing` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Occupancy_Pricing'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\TFH\\Room_Occupancy.Occupancy_Pricing';

-- --------------------------------------------------------

--
-- Table structure for table `Room_Occupancy_Limits`
--

CREATE TABLE `Room_Occupancy_Limits` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `Default_From` int(11) DEFAULT NULL COMMENT 'Column for property value: Default_From',
  `Default_To` int(11) DEFAULT NULL COMMENT 'Column for property value: Default_To',
  `Min` int(11) DEFAULT NULL COMMENT 'Column for property value: Min',
  `Max` int(11) DEFAULT NULL COMMENT 'Column for property value: Max'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Room_Occupancy_Limit';

-- --------------------------------------------------------

--
-- Table structure for table `Room_Occupancy_Pricing`
--

CREATE TABLE `Room_Occupancy_Pricing` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Property` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Property',
  `$Rate_Plan` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Rate_Plan',
  `Type` enum('infant','toddler','child','adolescent','adult') DEFAULT NULL COMMENT 'Column for property value: Type',
  `Bed_Type` enum('no_bed','regular_bed','extra_bed') DEFAULT NULL COMMENT 'Column for property value: Bed_Type',
  `Index` smallint(6) DEFAULT NULL COMMENT 'Column for property value: Index',
  `$Combination_Of` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Combination_Of',
  `Infant_Count` smallint(6) DEFAULT NULL COMMENT 'Column for property value: Infant_Count',
  `Toddler_Count` smallint(6) DEFAULT NULL COMMENT 'Column for property value: Toddler_Count',
  `Child_Count` smallint(6) DEFAULT NULL COMMENT 'Column for property value: Child_Count',
  `Adolescent_Count` smallint(6) DEFAULT NULL COMMENT 'Column for property value: Adolescent_Count',
  `Adult_Count` smallint(6) DEFAULT NULL COMMENT 'Column for property value: Adult_Count',
  `Pricing_Mode` enum('disabled','calendar_segment','relative_to','fee','free','as_adult') DEFAULT NULL COMMENT 'Column for property value: Pricing_Mode',
  `$Relative_To` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Relative_To',
  `Percent` decimal(6,2) DEFAULT NULL COMMENT 'Column for property value: Percent',
  `Fixed` decimal(11,2) DEFAULT NULL COMMENT 'Column for property value: Fixed',
  `Meal` enum('included','not_included') DEFAULT NULL COMMENT 'Column for property value: Meal',
  `Extra_Bed` enum('included','not_included','not_included_mandatory') DEFAULT NULL COMMENT 'Column for property value: Extra_Bed',
  `$$App$Room_Occupancy_Pricing` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Room_Occupancy_Pricing`.`Room_Occupancy_Pricing` column role'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Room_Occupancy_Pricing[]';

-- --------------------------------------------------------

--
-- Table structure for table `Room_Occupants`
--

CREATE TABLE `Room_Occupants` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `Gender` enum('Male','Female') DEFAULT NULL COMMENT 'Column for property value: Gender',
  `Type` enum('infant','toddler','child','adolescent','adult') DEFAULT NULL COMMENT 'Column for property value: Type',
  `First_Name` varchar(255) DEFAULT NULL COMMENT 'Column for property value: First_Name',
  `Last_Name` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Last_Name',
  `Date_Of_Birth` date DEFAULT NULL COMMENT 'Column for property value: Date_Of_Birth',
  `Age_At_Checkin` int(11) DEFAULT NULL COMMENT 'Column for property value: Age_At_Checkin'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Room_Occupant';

-- --------------------------------------------------------

--
-- Table structure for table `Room_Order_Item_Configs`
--

CREATE TABLE `Room_Order_Item_Configs` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Property` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Property',
  `$Room` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Room',
  `$Rate_Plan` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Rate_Plan',
  `$Restrictions` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Restrictions',
  `Check_In` date DEFAULT NULL COMMENT 'Column for property value: Check_In',
  `Nights` int(11) DEFAULT NULL COMMENT 'Column for property value: Nights',
  `$Occupancy` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Occupancy',
  `Corporate_Code_Used` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Corporate_Code_Used',
  `Search_Record` text DEFAULT NULL COMMENT 'Column for property value: Search_Record',
  `Search_Record_Headings` text DEFAULT NULL COMMENT 'Column for property value: Search_Record_Headings',
  `Payment_Policy` text DEFAULT NULL COMMENT 'Column for property value: Payment_Policy',
  `Cancellation_Policy` text DEFAULT NULL COMMENT 'Column for property value: Cancellation_Policy',
  `Meal_Option` enum('none','breakfast','half_board','full_board','all_inclusive') DEFAULT NULL COMMENT 'Column for property value: Meal_Option',
  `Meal_Name` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Meal_Name',
  `Reserved` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Reserved',
  `Pulled_By_Hotel_API` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Pulled_By_Hotel_API',
  `Room_Name` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Room_Name',
  `Rate_Plan_Name` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Rate_Plan_Name',
  `Corporate_Codes` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Corporate_Codes',
  `Index` int(11) DEFAULT NULL COMMENT 'Column for property value: Index'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Room_Order_Item_Config';

-- --------------------------------------------------------

--
-- Table structure for table `Room_Order_Item_Configs_Extra_Services`
--

CREATE TABLE `Room_Order_Item_Configs_Extra_Services` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Room_Order_Item_Configs` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Room_Order_Item_Configs_Extra_Services`.`Extra_Services` column role',
  `$Extra_Services` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Extra_Services'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\TFH\\Room_Order_Item_Config.Extra_Services';

-- --------------------------------------------------------

--
-- Table structure for table `Room_Order_Item_Configs_Nights_Costs`
--

CREATE TABLE `Room_Order_Item_Configs_Nights_Costs` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Room_Order_Item_Configs` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Room_Order_Item_Configs_Nights_Costs`.`Nights_Costs` column role',
  `Nights_Costs` float DEFAULT NULL COMMENT 'Column for property value: Nights_Costs'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\TFH\\Room_Order_Item_Config.Nights_Costs';

-- --------------------------------------------------------

--
-- Table structure for table `Room_Order_Item_Configs_Occupants`
--

CREATE TABLE `Room_Order_Item_Configs_Occupants` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Room_Order_Item_Configs` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Room_Order_Item_Configs_Occupants`.`Occupants` column role',
  `$Occupants` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Occupants'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\TFH\\Room_Order_Item_Config.Occupants';

-- --------------------------------------------------------

--
-- Table structure for table `Search_Locations`
--

CREATE TABLE `Search_Locations` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$$App$Search_Locations` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Search_Locations`.`Search_Locations` column role',
  `Caption` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Caption'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Search_Location';

-- --------------------------------------------------------

--
-- Table structure for table `Search_Locations_Addresses`
--

CREATE TABLE `Search_Locations_Addresses` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Search_Locations` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Search_Locations_Addresses`.`Addresses` column role',
  `$Addresses` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Addresses'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\TFH\\Search_Location.Addresses';

-- --------------------------------------------------------

--
-- Table structure for table `Search_Offers`
--

CREATE TABLE `Search_Offers` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Country` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Country',
  `Check_In_From` date DEFAULT NULL COMMENT 'Column for property value: Check_In_From',
  `Check_In_To` date DEFAULT NULL COMMENT 'Column for property value: Check_In_To',
  `Nights_From` int(11) DEFAULT NULL COMMENT 'Column for property value: Nights_From',
  `Nights_To` int(11) DEFAULT NULL COMMENT 'Column for property value: Nights_To',
  `Price_Mode` enum('Per Night','Per Stay') DEFAULT NULL COMMENT 'Column for property value: Price_Mode',
  `Price_From` int(11) DEFAULT NULL COMMENT 'Column for property value: Price_From',
  `Price_To` int(11) DEFAULT NULL COMMENT 'Column for property value: Price_To',
  `Stars_From` int(11) DEFAULT NULL COMMENT 'Column for property value: Stars_From',
  `Adults` int(11) DEFAULT NULL COMMENT 'Column for property value: Adults',
  `Children_Ages` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Children_Ages',
  `Property_Name` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Property_Name',
  `Order_By` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Order_By',
  `$Property_Facil_Top` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Property_Facil_Top',
  `$Property_Room_Facil_Top` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Property_Room_Facil_Top',
  `$Channel_Corporate_Code` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Channel_Corporate_Code',
  `$Property_Corporate_Code` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Property_Corporate_Code'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Search_Offers';

-- --------------------------------------------------------

--
-- Table structure for table `Search_Offers_Available_Rooms`
--

CREATE TABLE `Search_Offers_Available_Rooms` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Search_Offers` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Search_Offers_Available_Rooms`.`Available_Rooms` column role',
  `Available_Rooms` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Available_Rooms'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\TFH\\Search_Offers.Available_Rooms';

-- --------------------------------------------------------

--
-- Table structure for table `Search_Offers_Cancellation_Policy_Text`
--

CREATE TABLE `Search_Offers_Cancellation_Policy_Text` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Search_Offers` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Search_Offers_Cancellation_Policy_Text`.`Cancellation_Policy_Text` column role',
  `Cancellation_Policy_Text` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Cancellation_Policy_Text'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\TFH\\Search_Offers.Cancellation_Policy_Text';

-- --------------------------------------------------------

--
-- Table structure for table `Search_Offers_Cities`
--

CREATE TABLE `Search_Offers_Cities` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Search_Offers` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Search_Offers_Cities`.`Cities` column role',
  `$Cities` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Cities'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\TFH\\Search_Offers.Cities';

-- --------------------------------------------------------

--
-- Table structure for table `Search_Offers_Contract_Was_Signed`
--

CREATE TABLE `Search_Offers_Contract_Was_Signed` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Search_Offers` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Search_Offers_Contract_Was_Signed`.`Contract_Was_Signed` column role',
  `Contract_Was_Signed` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Contract_Was_Signed'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\TFH\\Search_Offers.Contract_Was_Signed';

-- --------------------------------------------------------

--
-- Table structure for table `Search_Offers_Facility`
--

CREATE TABLE `Search_Offers_Facility` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Search_Offers` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Search_Offers_Facility`.`Facility` column role',
  `Facility` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Facility'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\TFH\\Search_Offers.Facility';

-- --------------------------------------------------------

--
-- Table structure for table `Search_Offers_Has_Corporate_Code`
--

CREATE TABLE `Search_Offers_Has_Corporate_Code` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Search_Offers` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Search_Offers_Has_Corporate_Code`.`Has_Corporate_Code` column role',
  `Has_Corporate_Code` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Has_Corporate_Code'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\TFH\\Search_Offers.Has_Corporate_Code';

-- --------------------------------------------------------

--
-- Table structure for table `Search_Offers_Meal`
--

CREATE TABLE `Search_Offers_Meal` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Search_Offers` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Search_Offers_Meal`.`Meal` column role',
  `Meal` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Meal'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\TFH\\Search_Offers.Meal';

-- --------------------------------------------------------

--
-- Table structure for table `Search_Offers_Missing_Contract`
--

CREATE TABLE `Search_Offers_Missing_Contract` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Search_Offers` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Search_Offers_Missing_Contract`.`Missing_Contract` column role',
  `Missing_Contract` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Missing_Contract'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\TFH\\Search_Offers.Missing_Contract';

-- --------------------------------------------------------

--
-- Table structure for table `Search_Offers_Payment_Policy_Text`
--

CREATE TABLE `Search_Offers_Payment_Policy_Text` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Search_Offers` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Search_Offers_Payment_Policy_Text`.`Payment_Policy_Text` column role',
  `Payment_Policy_Text` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Payment_Policy_Text'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\TFH\\Search_Offers.Payment_Policy_Text';

-- --------------------------------------------------------

--
-- Table structure for table `Search_Offers_Properties`
--

CREATE TABLE `Search_Offers_Properties` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Search_Offers` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Search_Offers_Properties`.`Properties` column role',
  `$Properties` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Properties'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\TFH\\Search_Offers.Properties';

-- --------------------------------------------------------

--
-- Table structure for table `Search_Offers_Property_Type`
--

CREATE TABLE `Search_Offers_Property_Type` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Search_Offers` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Search_Offers_Property_Type`.`Property_Type` column role',
  `Property_Type` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Property_Type'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\TFH\\Search_Offers.Property_Type';

-- --------------------------------------------------------

--
-- Table structure for table `Search_Offers_Rooms_Count`
--

CREATE TABLE `Search_Offers_Rooms_Count` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Search_Offers` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Search_Offers_Rooms_Count`.`Rooms_Count` column role',
  `Rooms_Count` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Rooms_Count'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\TFH\\Search_Offers.Rooms_Count';

-- --------------------------------------------------------

--
-- Table structure for table `Search_Offers_Room_Facility`
--

CREATE TABLE `Search_Offers_Room_Facility` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Search_Offers` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Search_Offers_Room_Facility`.`Room_Facility` column role',
  `Room_Facility` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Room_Facility'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\TFH\\Search_Offers.Room_Facility';

-- --------------------------------------------------------

--
-- Table structure for table `Search_Offers_Stars`
--

CREATE TABLE `Search_Offers_Stars` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Search_Offers` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Search_Offers_Stars`.`Stars` column role',
  `Stars` int(11) DEFAULT NULL COMMENT 'Column for property value: Stars'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\TFH\\Search_Offers.Stars';

-- --------------------------------------------------------

--
-- Table structure for table `Search_Rooms`
--

CREATE TABLE `Search_Rooms` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `Adults` int(11) DEFAULT NULL COMMENT 'Column for property value: Adults',
  `Children` int(11) DEFAULT NULL COMMENT 'Column for property value: Children',
  `Infants` int(11) DEFAULT NULL COMMENT 'Column for property value: Infants',
  `Children_Ages` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Children_Ages',
  `Count` int(11) DEFAULT NULL COMMENT 'Column for property value: Count'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Search_Room';

-- --------------------------------------------------------

--
-- Table structure for table `Seasons`
--

CREATE TABLE `Seasons` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `Name` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Name',
  `$Owner` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Owner',
  `$$App$Seasons` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Seasons`.`Seasons` column role'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Season[]';

-- --------------------------------------------------------

--
-- Table structure for table `Seasons_Season_Time`
--

CREATE TABLE `Seasons_Season_Time` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Seasons` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Seasons_Season_Time`.`Season_Time` column role',
  `$Season_Time` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Season_Time'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\TFH\\Season.Season_Time';

-- --------------------------------------------------------

--
-- Table structure for table `Season_Time`
--

CREATE TABLE `Season_Time` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `From` date DEFAULT NULL COMMENT 'Column for property value: From',
  `To` date DEFAULT NULL COMMENT 'Column for property value: To'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Season_Time';

-- --------------------------------------------------------

--
-- Table structure for table `Seo_Images`
--

CREATE TABLE `Seo_Images` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `Name` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Name',
  `Path` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Path',
  `Alt` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Alt',
  `Order` int(11) DEFAULT NULL COMMENT 'Column for property value: Order'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\SeoImage';

-- --------------------------------------------------------

--
-- Table structure for table `Seo_Video_Embed`
--

CREATE TABLE `Seo_Video_Embed` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `Name` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Name',
  `Path` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Path',
  `Order` int(11) DEFAULT NULL COMMENT 'Column for property value: Order'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\SeoVideoEmbed';

-- --------------------------------------------------------

--
-- Table structure for table `Services_Calendar`
--

CREATE TABLE `Services_Calendar` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `Name` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Name',
  `$Owner` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Owner',
  `$$App$Services_Calendar` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Services_Calendar`.`Services_Calendar` column role'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Service_Calendar[]';

-- --------------------------------------------------------

--
-- Table structure for table `Services_Calendar_Dates`
--

CREATE TABLE `Services_Calendar_Dates` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Calendar` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Calendar',
  `Date` date DEFAULT NULL COMMENT 'Column for property value: Date',
  `Status` enum('open','closed') DEFAULT NULL COMMENT 'Column for property value: Status'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Service_Calendar_Date';

-- --------------------------------------------------------

--
-- Table structure for table `Sessions`
--

CREATE TABLE `Sessions` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `SessionId` varchar(255) DEFAULT NULL COMMENT 'Column for property value: SessionId',
  `IP` varchar(255) DEFAULT NULL COMMENT 'Column for property value: IP'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\Session';

-- --------------------------------------------------------

--
-- Table structure for table `Sessions_Data_`
--

CREATE TABLE `Sessions_Data_` (
  `$id` bigint(20) UNSIGNED NOT NULL,
  `Session_Id` varchar(40) NOT NULL DEFAULT '',
  `IP` varchar(46) NOT NULL DEFAULT '',
  `C_Time` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `M_Time` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `A_Time` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `Data` mediumblob NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- --------------------------------------------------------

--
-- Table structure for table `Special_Deals`
--

CREATE TABLE `Special_Deals` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `Date_Start` date DEFAULT NULL COMMENT 'Column for property value: Date_Start',
  `Date_End` date DEFAULT NULL COMMENT 'Column for property value: Date_End',
  `Checkin_Restricted` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Checkin_Restricted',
  `Checkin_From_Date` date DEFAULT NULL COMMENT 'Column for property value: Checkin_From_Date',
  `Checkin_Until_Date` date DEFAULT NULL COMMENT 'Column for property value: Checkin_Until_Date',
  `Min_Days_Until_Checkin` int(11) DEFAULT NULL COMMENT 'Column for property value: Min_Days_Until_Checkin',
  `Max_Days_Until_Checkin` int(11) DEFAULT NULL COMMENT 'Column for property value: Max_Days_Until_Checkin',
  `Type` enum('special_offer','early_booking','last_minute') DEFAULT NULL COMMENT 'Column for property value: Type',
  `$Special_Offer` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Special_Offer',
  `Available_On_All_Rooms` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Available_On_All_Rooms',
  `Available_On_All_Rates` tinyint(1) DEFAULT NULL COMMENT 'Column for property value: Available_On_All_Rates',
  `$Property` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Property',
  `$Owner` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Owner',
  `$$App$Special_Deals` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Special_Deals`.`Special_Deals` column role'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Special_Deal[]';

-- --------------------------------------------------------

--
-- Table structure for table `Special_Deals_TFH_Rooms`
--

CREATE TABLE `Special_Deals_TFH_Rooms` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Special_Deals` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Special_Deals_TFH_Rooms`.`TFH_Rooms` column role',
  `$TFH_Rooms` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: TFH_Rooms'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\TFH\\Special_Deal.TFH_Rooms';

-- --------------------------------------------------------

--
-- Table structure for table `Special_Offer_Deal`
--

CREATE TABLE `Special_Offer_Deal` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `Discount_Type` enum('percent','fixed') DEFAULT NULL COMMENT 'Column for property value: Discount_Type',
  `Percent` float DEFAULT NULL COMMENT 'Column for property value: Percent',
  `Fixed` float DEFAULT NULL COMMENT 'Column for property value: Fixed',
  `$Payment_Policy` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Payment_Policy',
  `$Cancellation_Policy` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Cancellation_Policy'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Special_Offer_Deal';

-- --------------------------------------------------------

--
-- Table structure for table `Store_Locations`
--

CREATE TABLE `Store_Locations` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `Name` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Name',
  `$App_Store_Locations` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Store_Locations`.`Store_Locations` column role'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Store_Location[]';

-- --------------------------------------------------------

--
-- Table structure for table `Store_Locations_Addresses`
--

CREATE TABLE `Store_Locations_Addresses` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Store_Locations` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Store_Locations_Addresses`.`Addresses` column role',
  `$Addresses` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Addresses'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\TFH\\Store_Location.Addresses';

-- --------------------------------------------------------

--
-- Table structure for table `Terms_And_Conditions_Pages`
--

CREATE TABLE `Terms_And_Conditions_Pages` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$$App$Terms_And_Conditions_Pages` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Terms_And_Conditions_Pages`.`Terms_And_Conditions_Pages` column role',
  `Version` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Version',
  `Active` tinyint(1) DEFAULT 0 COMMENT 'Column for property value: Active',
  `Content_HTML` mediumtext DEFAULT NULL COMMENT 'Column for property value: Content_HTML',
  `Is_Default` tinyint(1) DEFAULT 0 COMMENT 'Column for property value: Is_Default',
  `Date` date DEFAULT NULL COMMENT 'Column for property value: Date',
  `$$App$Privacy_Policy_Pages` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Terms_And_Conditions_Pages`.`Privacy_Policy_Pages` column role'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\Terms_And_Conditions_Page[]';

-- --------------------------------------------------------

--
-- Table structure for table `Texts`
--

CREATE TABLE `Texts` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$$App$Texts` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.Texts`.`Texts` column role',
  `Key` varchar(512) DEFAULT NULL COMMENT 'Column for property value: Key',
  `Value` varchar(8192) DEFAULT NULL COMMENT 'Column for property value: Value',
  `Text` longtext DEFAULT NULL COMMENT 'Column for property value: Text'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\Text';

-- --------------------------------------------------------

--
-- Table structure for table `TFH_Offer`
--

CREATE TABLE `TFH_Offer` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Property` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Property',
  `$Property_Room` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Property_Room',
  `$Rate_Plan` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Rate_Plan',
  `$Meal` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Meal',
  `Total_Price` float DEFAULT NULL COMMENT 'Column for property value: Total_Price',
  `Comission` float DEFAULT NULL COMMENT 'Column for property value: Comission',
  `Currency_Code` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Currency_Code',
  `Check_In_Date` date DEFAULT NULL COMMENT 'Column for property value: Check_In_Date',
  `Nights` int(11) DEFAULT NULL COMMENT 'Column for property value: Nights',
  `Available_Rooms` int(11) DEFAULT NULL COMMENT 'Column for property value: Available_Rooms',
  `Corporate_Codes` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Corporate_Codes'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\TFH_Offer';

-- --------------------------------------------------------

--
-- Table structure for table `TFH_Offer_Cancellation_Policy`
--

CREATE TABLE `TFH_Offer_Cancellation_Policy` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$TFH_Offer` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.TFH_Offer_Cancellation_Policy`.`Cancellation_Policy` column role',
  `Cancellation_Policy` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Cancellation_Policy'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\TFH\\TFH_Offer.Cancellation_Policy';

-- --------------------------------------------------------

--
-- Table structure for table `TFH_Offer_Extra_Services`
--

CREATE TABLE `TFH_Offer_Extra_Services` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$TFH_Offer` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.TFH_Offer_Extra_Services`.`Extra_Services` column role',
  `$Extra_Services` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Extra_Services'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\TFH\\TFH_Offer.Extra_Services';

-- --------------------------------------------------------

--
-- Table structure for table `TFH_Offer_Occupants`
--

CREATE TABLE `TFH_Offer_Occupants` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$TFH_Offer` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.TFH_Offer_Occupants`.`Occupants` column role',
  `$Occupants` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Occupants'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\TFH\\TFH_Offer.Occupants';

-- --------------------------------------------------------

--
-- Table structure for table `TFH_Offer_Payment_Policy`
--

CREATE TABLE `TFH_Offer_Payment_Policy` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$TFH_Offer` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.TFH_Offer_Payment_Policy`.`Payment_Policy` column role',
  `Payment_Policy` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Payment_Policy'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\TFH\\TFH_Offer.Payment_Policy';

-- --------------------------------------------------------

--
-- Table structure for table `User_Access_Templates`
--

CREATE TABLE `User_Access_Templates` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `Name` varchar(255) DEFAULT NULL COMMENT 'Column for property value: Name',
  `$Owner` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Owner',
  `$$App$User_Access_Templates` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.User_Access_Templates`.`User_Access_Templates` column role'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for class: Omi\\TFH\\User_Access[]';

-- --------------------------------------------------------

--
-- Table structure for table `User_Access_Templates_Properties`
--

CREATE TABLE `User_Access_Templates_Properties` (
  `$id` int(10) UNSIGNED NOT NULL COMMENT 'Id/RowId column role',
  `$Properties` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference column for property value: Properties',
  `$User_Access_Templates` int(10) UNSIGNED DEFAULT NULL COMMENT 'Reference to `tf_demo_tmp.User_Access_Templates_Properties`.`Properties` column role'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci COMMENT='Storage for collection: Omi\\TFH\\User_Access.Properties';

--
-- Indexes for dumped tables
--

--
-- Indexes for table `$App`
--
ALTER TABLE `$App`
  ADD PRIMARY KEY (`$id`);

--
-- Indexes for table `$GroupRelations`
--
ALTER TABLE `$GroupRelations`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Subject` (`$Subject`);

--
-- Indexes for table `$GroupRelations_Groups`
--
ALTER TABLE `$GroupRelations_Groups`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$$GroupRelations` (`$$GroupRelations`),
  ADD KEY `$Groups` (`$Groups`);

--
-- Indexes for table `$UserGroups`
--
ALTER TABLE `$UserGroups`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$SelfUser` (`$SelfUser`);

--
-- Indexes for table `$UserGroups_Groups`
--
ALTER TABLE `$UserGroups_Groups`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$$UserGroups` (`$$UserGroups`),
  ADD KEY `$Groups` (`$Groups`);

--
-- Indexes for table `$UserGroups_Relations`
--
ALTER TABLE `$UserGroups_Relations`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$$UserGroups` (`$$UserGroups`),
  ADD KEY `$Relations` (`$Relations`);

--
-- Indexes for table `$Users`
--
ALTER TABLE `$Users`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Mail_Sender` (`$Mail_Sender`),
  ADD KEY `$Reverse_APIs` (`$Reverse_APIs`),
  ADD KEY `$TFH_API_System` (`$TFH_API_System`),
  ADD KEY `$Cart` (`$Cart`),
  ADD KEY `$Access_Template` (`$Access_Template`),
  ADD KEY `$Owner` (`$Owner`),
  ADD KEY `$Favorite_Order` (`$Favorite_Order`),
  ADD KEY `BackendAccess` (`BackendAccess`),
  ADD KEY `IsDefault` (`IsDefault`),
  ADD KEY `Phone` (`Phone`),
  ADD KEY `Active` (`Active`),
  ADD KEY `ActivationCode` (`ActivationCode`),
  ADD KEY `PasswordRecoveryCode` (`PasswordRecoveryCode`),
  ADD KEY `PrevPwd` (`PrevPwd`),
  ADD KEY `$Person` (`$Person`),
  ADD KEY `LoggedToSystem` (`LoggedToSystem`),
  ADD KEY `Username` (`Username`),
  ADD KEY `$Language` (`$Language`),
  ADD KEY `$UI_Language` (`$UI_Language`),
  ADD KEY `Email` (`Email`),
  ADD KEY `$SelfGroup` (`$SelfGroup`),
  ADD KEY `$$App$Users` (`$$App$Users`);

--
-- Indexes for table `$UsersGroupsList`
--
ALTER TABLE `$UsersGroupsList`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Group` (`$Group`),
  ADD KEY `$User` (`$User`);

--
-- Indexes for table `$Users_Access`
--
ALTER TABLE `$Users_Access`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$$Users` (`$$Users`),
  ADD KEY `$Access` (`$Access`);

--
-- Indexes for table `$Users_Authorized_IPs`
--
ALTER TABLE `$Users_Authorized_IPs`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$$Users` (`$$Users`);

--
-- Indexes for table `$Users_Notifications`
--
ALTER TABLE `$Users_Notifications`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$$Users` (`$$Users`),
  ADD KEY `$Notifications` (`$Notifications`);

--
-- Indexes for table `Account_Configurations`
--
ALTER TABLE `Account_Configurations`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$$App$Account_Configurations` (`$$App$Account_Configurations`),
  ADD KEY `$Owner` (`$Owner`);

--
-- Indexes for table `Addresses`
--
ALTER TABLE `Addresses`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$City` (`$City`),
  ADD KEY `$County` (`$County`),
  ADD KEY `$Country` (`$Country`),
  ADD KEY `$Actor` (`$Actor`),
  ADD KEY `$$App$Addresses` (`$$App$Addresses`);

--
-- Indexes for table `Age_Intervals`
--
ALTER TABLE `Age_Intervals`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Property` (`$Property`),
  ADD KEY `$Owner` (`$Owner`),
  ADD KEY `$$App$Age_Intervals` (`$$App$Age_Intervals`);

--
-- Indexes for table `API_Systems`
--
ALTER TABLE `API_Systems`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$$App$API_Systems` (`$$App$API_Systems`);

--
-- Indexes for table `Bank_Accounts`
--
ALTER TABLE `Bank_Accounts`
  ADD PRIMARY KEY (`$id`);

--
-- Indexes for table `BNR_Rates`
--
ALTER TABLE `BNR_Rates`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `Date` (`Date`);

--
-- Indexes for table `Cache_View`
--
ALTER TABLE `Cache_View`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$$App$Cache_Views` (`$$App$Cache_Views`);

--
-- Indexes for table `Cancellation_Policies`
--
ALTER TABLE `Cancellation_Policies`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `Remote_Id` (`Remote_Id`),
  ADD KEY `$Owner` (`$Owner`),
  ADD KEY `$$App$Cancellation_Policies` (`$$App$Cancellation_Policies`);

--
-- Indexes for table `Cancellation_Policies_Items`
--
ALTER TABLE `Cancellation_Policies_Items`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Cancellation_Policies` (`$Cancellation_Policies`),
  ADD KEY `$Items` (`$Items`);

--
-- Indexes for table `Channel_Contract`
--
ALTER TABLE `Channel_Contract`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Property` (`$Property`),
  ADD KEY `$Channel` (`$Channel`),
  ADD KEY `$Terms_Accepted_User` (`$Terms_Accepted_User`),
  ADD KEY `$Contract_Signed_User` (`$Contract_Signed_User`);

--
-- Indexes for table `Channel_Corporate_Codes`
--
ALTER TABLE `Channel_Corporate_Codes`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Owner` (`$Owner`),
  ADD KEY `$$App$Channel_Corporate_Codes` (`$$App$Channel_Corporate_Codes`);

--
-- Indexes for table `Checkout_Orders`
--
ALTER TABLE `Checkout_Orders`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$$App$Checkout_Orders` (`$$App$Checkout_Orders`),
  ADD KEY `$Buyer` (`$Buyer`),
  ADD KEY `$Buyer_Company` (`$Buyer_Company`),
  ADD KEY `$Created_By` (`$Created_By`),
  ADD KEY `$Beneficiary_Company` (`$Beneficiary_Company`);

--
-- Indexes for table `Checkout_Orders_Offers`
--
ALTER TABLE `Checkout_Orders_Offers`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Checkout_Orders` (`$Checkout_Orders`),
  ADD KEY `$Offers` (`$Offers`);

--
-- Indexes for table `Cities`
--
ALTER TABLE `Cities`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$TFH_Search_City` (`$TFH_Search_City`),
  ADD KEY `$County` (`$County`),
  ADD KEY `$Country` (`$Country`),
  ADD KEY `$$App$Cities` (`$$App$Cities`);

--
-- Indexes for table `Cities_TFH_Search_Cities`
--
ALTER TABLE `Cities_TFH_Search_Cities`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Cities` (`$Cities`),
  ADD KEY `$TFH_Search_Cities` (`$TFH_Search_Cities`);

--
-- Indexes for table `Cities_TFH_Search_Properties`
--
ALTER TABLE `Cities_TFH_Search_Properties`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Cities` (`$Cities`),
  ADD KEY `$TFH_Search_Properties` (`$TFH_Search_Properties`);

--
-- Indexes for table `Companies`
--
ALTER TABLE `Companies`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Logo` (`$Logo`),
  ADD KEY `$Mail_Sender` (`$Mail_Sender`),
  ADD KEY `$Customer_Of` (`$Customer_Of`),
  ADD KEY `$Language_Email_Notifications` (`$Language_Email_Notifications`),
  ADD KEY `$Address` (`$Address`),
  ADD KEY `$$App$Companies` (`$$App$Companies`);

--
-- Indexes for table `Companies_Accessible_By`
--
ALTER TABLE `Companies_Accessible_By`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Companies` (`$Companies`),
  ADD KEY `$Accessible_By` (`$Accessible_By`);

--
-- Indexes for table `Companies_Api_IPs`
--
ALTER TABLE `Companies_Api_IPs`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Companies` (`$Companies`);

--
-- Indexes for table `Companies_Bank_Accounts`
--
ALTER TABLE `Companies_Bank_Accounts`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Companies` (`$Companies`),
  ADD KEY `$Bank_Accounts` (`$Bank_Accounts`);

--
-- Indexes for table `Companies_Contacts`
--
ALTER TABLE `Companies_Contacts`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Companies` (`$Companies`),
  ADD KEY `$Contacts` (`$Contacts`);

--
-- Indexes for table `Companies_Contact_Emails_List`
--
ALTER TABLE `Companies_Contact_Emails_List`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Companies` (`$Companies`),
  ADD KEY `$Contact_Emails_List` (`$Contact_Emails_List`);

--
-- Indexes for table `Companies_Contact_Phones_List`
--
ALTER TABLE `Companies_Contact_Phones_List`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Companies` (`$Companies`),
  ADD KEY `$Contact_Phones_List` (`$Contact_Phones_List`);

--
-- Indexes for table `Companies_Emails_List`
--
ALTER TABLE `Companies_Emails_List`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Companies` (`$Companies`);

--
-- Indexes for table `Companies_Phones_List`
--
ALTER TABLE `Companies_Phones_List`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Companies` (`$Companies`);

--
-- Indexes for table `Contact_Information`
--
ALTER TABLE `Contact_Information`
  ADD PRIMARY KEY (`$id`);

--
-- Indexes for table `Content`
--
ALTER TABLE `Content`
  ADD PRIMARY KEY (`$id`);

--
-- Indexes for table `Corporate_Codes`
--
ALTER TABLE `Corporate_Codes`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Owner` (`$Owner`),
  ADD KEY `$$App$Corporate_Codes` (`$$App$Corporate_Codes`);

--
-- Indexes for table `Corporate_Codes_Accessible_To`
--
ALTER TABLE `Corporate_Codes_Accessible_To`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Corporate_Codes` (`$Corporate_Codes`),
  ADD KEY `$Accessible_To` (`$Accessible_To`);

--
-- Indexes for table `Corporate_Codes_Rate_Plans`
--
ALTER TABLE `Corporate_Codes_Rate_Plans`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Rate_Plans` (`$Rate_Plans`),
  ADD KEY `$Corporate_Codes` (`$Corporate_Codes`);

--
-- Indexes for table `Counties`
--
ALTER TABLE `Counties`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Country` (`$Country`),
  ADD KEY `$$App$Counties` (`$$App$Counties`);

--
-- Indexes for table `Countries`
--
ALTER TABLE `Countries`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$$App$Countries` (`$$App$Countries`);

--
-- Indexes for table `Dates_Intervals`
--
ALTER TABLE `Dates_Intervals`
  ADD PRIMARY KEY (`$id`);

--
-- Indexes for table `Dates_Intervals_End_Date`
--
ALTER TABLE `Dates_Intervals_End_Date`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Dates_Intervals` (`$Dates_Intervals`);

--
-- Indexes for table `Dates_Intervals_Start_Date`
--
ALTER TABLE `Dates_Intervals_Start_Date`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Dates_Intervals` (`$Dates_Intervals`);

--
-- Indexes for table `Date_Room`
--
ALTER TABLE `Date_Room`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$$App$Date_Room` (`$$App$Date_Room`),
  ADD KEY `$Room` (`$Room`);

--
-- Indexes for table `Date_Room_Rate`
--
ALTER TABLE `Date_Room_Rate`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Rate` (`$Rate`),
  ADD KEY `$Restrictions` (`$Restrictions`);

--
-- Indexes for table `Date_Room_Rates`
--
ALTER TABLE `Date_Room_Rates`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Date_Room` (`$Date_Room`),
  ADD KEY `$Rates` (`$Rates`);

--
-- Indexes for table `Documents`
--
ALTER TABLE `Documents`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$User` (`$User`);

--
-- Indexes for table `DRR_Logs`
--
ALTER TABLE `DRR_Logs`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$$App$DRR_Logs` (`$$App$DRR_Logs`),
  ADD KEY `$Request_Log` (`$Request_Log`);

--
-- Indexes for table `Emails_Sent`
--
ALTER TABLE `Emails_Sent`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `Date` (`Date`);

--
-- Indexes for table `Extra_Beds_Limits`
--
ALTER TABLE `Extra_Beds_Limits`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Room` (`$Room`);

--
-- Indexes for table `FailedLogins`
--
ALTER TABLE `FailedLogins`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$$App$FailedLogins` (`$$App$FailedLogins`);

--
-- Indexes for table `Favorite_Orders`
--
ALTER TABLE `Favorite_Orders`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Created_By` (`$Created_By`),
  ADD KEY `Date` (`Date`),
  ADD KEY `$Owner` (`$Owner`),
  ADD KEY `$$App$Favorite_Orders` (`$$App$Favorite_Orders`);

--
-- Indexes for table `Favorite_Orders_Favorite_Offers`
--
ALTER TABLE `Favorite_Orders_Favorite_Offers`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Favorite_Orders` (`$Favorite_Orders`),
  ADD KEY `$Favorite_Offers` (`$Favorite_Offers`);

--
-- Indexes for table `Favorite_Order_Email`
--
ALTER TABLE `Favorite_Order_Email`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$$App$Favorite_Order_Emails` (`$$App$Favorite_Order_Emails`),
  ADD KEY `$Favorite_Order` (`$Favorite_Order`),
  ADD KEY `$Created_By` (`$Created_By`),
  ADD KEY `Date` (`Date`);

--
-- Indexes for table `Favorite_Order_Email_Emails`
--
ALTER TABLE `Favorite_Order_Email_Emails`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Favorite_Order_Email` (`$Favorite_Order_Email`);

--
-- Indexes for table `Favorite_Order_Email_Favorite_Offers`
--
ALTER TABLE `Favorite_Order_Email_Favorite_Offers`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Favorite_Order_Email` (`$Favorite_Order_Email`),
  ADD KEY `$Favorite_Offers` (`$Favorite_Offers`);

--
-- Indexes for table `General_Properties_Facilities`
--
ALTER TABLE `General_Properties_Facilities`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$$App$General_Properties_Facilities` (`$$App$General_Properties_Facilities`);

--
-- Indexes for table `General_Properties_Room_Facilities`
--
ALTER TABLE `General_Properties_Room_Facilities`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$$App$General_Properties_Room_Facilities` (`$$App$General_Properties_Room_Facilities`);

--
-- Indexes for table `Identities`
--
ALTER TABLE `Identities`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$$App$Identities` (`$$App$Identities`),
  ADD KEY `$User` (`$User`),
  ADD KEY `$Session` (`$Session`);

--
-- Indexes for table `Invoices`
--
ALTER TABLE `Invoices`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$$App$Invoices` (`$$App$Invoices`),
  ADD KEY `Date` (`Date`),
  ADD KEY `Due_Date` (`Due_Date`),
  ADD KEY `$Series_Number` (`$Series_Number`),
  ADD KEY `$Invoiced_By` (`$Invoiced_By`),
  ADD KEY `$Invoiced_To_Channel` (`$Invoiced_To_Channel`),
  ADD KEY `$Invoiced_To_Property_Owner` (`$Invoiced_To_Property_Owner`),
  ADD KEY `$Made_By` (`$Made_By`),
  ADD KEY `$Representative` (`$Representative`),
  ADD KEY `$Language` (`$Language`),
  ADD KEY `$Owner` (`$Owner`);

--
-- Indexes for table `Invoices_Collected`
--
ALTER TABLE `Invoices_Collected`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$$App$Invoices_Collected` (`$$App$Invoices_Collected`),
  ADD KEY `$Payment_Type` (`$Payment_Type`),
  ADD KEY `Date` (`Date`),
  ADD KEY `$Invoice` (`$Invoice`),
  ADD KEY `$Bank_Account` (`$Bank_Account`),
  ADD KEY `$Client` (`$Client`),
  ADD KEY `$Owner` (`$Owner`);

--
-- Indexes for table `Invoices_Items`
--
ALTER TABLE `Invoices_Items`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Invoices` (`$Invoices`),
  ADD KEY `$Items` (`$Items`),
  ADD KEY `$VAT` (`$VAT`),
  ADD KEY `$Owner` (`$Owner`);

--
-- Indexes for table `Invoices_Orders`
--
ALTER TABLE `Invoices_Orders`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Invoices` (`$Invoices`),
  ADD KEY `$Orders` (`$Orders`);

--
-- Indexes for table `Invoices_Series`
--
ALTER TABLE `Invoices_Series`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Owner` (`$Owner`),
  ADD KEY `$$App$Invoices_Series` (`$$App$Invoices_Series`);

--
-- Indexes for table `Invoices_VAT_Rates`
--
ALTER TABLE `Invoices_VAT_Rates`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Owner` (`$Owner`),
  ADD KEY `$$App$Invoices_VAT_Rates` (`$$App$Invoices_VAT_Rates`);

--
-- Indexes for table `Invoice_Payment_Types`
--
ALTER TABLE `Invoice_Payment_Types`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$$App$Invoice_Payment_Types` (`$$App$Invoice_Payment_Types`),
  ADD KEY `$Owner` (`$Owner`);

--
-- Indexes for table `Key_Value`
--
ALTER TABLE `Key_Value`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Rate_Set_Request` (`$Rate_Set_Request`),
  ADD KEY `Key` (`Key`);

--
-- Indexes for table `Languages`
--
ALTER TABLE `Languages`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Owner` (`$Owner`),
  ADD KEY `$$App$Languages_Spoken` (`$$App$Languages_Spoken`),
  ADD KEY `$$App$Languages` (`$$App$Languages`),
  ADD KEY `$$App$Invoice_Languages` (`$$App$Invoice_Languages`);

--
-- Indexes for table `List_Offers`
--
ALTER TABLE `List_Offers`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$$App$List_Offers` (`$$App$List_Offers`),
  ADD KEY `$Search` (`$Search`);

--
-- Indexes for table `LoginLog`
--
ALTER TABLE `LoginLog`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$$App$LoginsLog` (`$$App$LoginsLog`),
  ADD KEY `$User` (`$User`);

--
-- Indexes for table `Mails_Senders`
--
ALTER TABLE `Mails_Senders`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Owner` (`$Owner`);

--
-- Indexes for table `Mails_Senders_ReplyTo`
--
ALTER TABLE `Mails_Senders_ReplyTo`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Mails_Senders` (`$Mails_Senders`);

--
-- Indexes for table `Notifications`
--
ALTER TABLE `Notifications`
  ADD PRIMARY KEY (`$id`);

--
-- Indexes for table `Offers`
--
ALTER TABLE `Offers`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `Remote_Id` (`Remote_Id`),
  ADD KEY `$TFH_Service_Calendar` (`$TFH_Service_Calendar`),
  ADD KEY `$Category` (`$Category`),
  ADD KEY `$Content` (`$Content`),
  ADD KEY `$Owner` (`$Owner`),
  ADD KEY `$$App$Offers` (`$$App$Offers`);

--
-- Indexes for table `Offers_Bundle_Items`
--
ALTER TABLE `Offers_Bundle_Items`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Offers` (`$Offers`),
  ADD KEY `$Bundle_Items` (`$Bundle_Items`);

--
-- Indexes for table `Offer_Category`
--
ALTER TABLE `Offer_Category`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$$App$Offer_Categories` (`$$App$Offer_Categories`);

--
-- Indexes for table `Offer_Discount`
--
ALTER TABLE `Offer_Discount`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Offer` (`$Offer`);

--
-- Indexes for table `Offer_Enforcements`
--
ALTER TABLE `Offer_Enforcements`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Offer` (`$Offer`);

--
-- Indexes for table `Offer_Enforcements_Offer_Enforcement_Items`
--
ALTER TABLE `Offer_Enforcements_Offer_Enforcement_Items`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Offer_Enforcements` (`$Offer_Enforcements`),
  ADD KEY `$Offer_Enforcement_Items` (`$Offer_Enforcement_Items`);

--
-- Indexes for table `Offer_Enforcement_Items`
--
ALTER TABLE `Offer_Enforcement_Items`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Offer_Enforcement` (`$Offer_Enforcement`),
  ADD KEY `$Offer` (`$Offer`),
  ADD KEY `$Discount` (`$Discount`);

--
-- Indexes for table `Orders`
--
ALTER TABLE `Orders`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Channel` (`$Channel`),
  ADD KEY `$Property` (`$Property`),
  ADD KEY `$Beneficiary_Company` (`$Beneficiary_Company`),
  ADD KEY `$BNR_Rate` (`$BNR_Rate`),
  ADD KEY `Remote_Id` (`Remote_Id`),
  ADD KEY `Date` (`Date`),
  ADD KEY `Last_Modified_Date` (`Last_Modified_Date`),
  ADD KEY `$Buyer` (`$Buyer`),
  ADD KEY `$Buyer_Company` (`$Buyer_Company`),
  ADD KEY `$Created_By` (`$Created_By`),
  ADD KEY `$Owner` (`$Owner`),
  ADD KEY `$$App$Orders` (`$$App$Orders`);

--
-- Indexes for table `Orders_Documents`
--
ALTER TABLE `Orders_Documents`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Orders` (`$Orders`),
  ADD KEY `$Documents` (`$Documents`);

--
-- Indexes for table `Orders_Emails_Sent`
--
ALTER TABLE `Orders_Emails_Sent`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Orders` (`$Orders`),
  ADD KEY `$Emails_Sent` (`$Emails_Sent`);

--
-- Indexes for table `Orders_Items`
--
ALTER TABLE `Orders_Items`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Order` (`$Order`),
  ADD KEY `$Parent` (`$Parent`),
  ADD KEY `$Offer` (`$Offer`),
  ADD KEY `$Config` (`$Config`);

--
-- Indexes for table `Orders_Reverse_Api_Log`
--
ALTER TABLE `Orders_Reverse_Api_Log`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Orders` (`$Orders`),
  ADD KEY `$Reverse_Api_Log` (`$Reverse_Api_Log`);

--
-- Indexes for table `Payment_Policies`
--
ALTER TABLE `Payment_Policies`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `Remote_Id` (`Remote_Id`),
  ADD KEY `$Owner` (`$Owner`),
  ADD KEY `$$App$Payment_Policies` (`$$App$Payment_Policies`);

--
-- Indexes for table `Payment_Policies_Items`
--
ALTER TABLE `Payment_Policies_Items`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Payment_Policies` (`$Payment_Policies`),
  ADD KEY `$Items` (`$Items`);

--
-- Indexes for table `Payment_Policy_Items`
--
ALTER TABLE `Payment_Policy_Items`
  ADD PRIMARY KEY (`$id`);

--
-- Indexes for table `Persons`
--
ALTER TABLE `Persons`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Address` (`$Address`),
  ADD KEY `$$App$Contacts` (`$$App$Contacts`);

--
-- Indexes for table `Price_Profile`
--
ALTER TABLE `Price_Profile`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Owner` (`$Owner`),
  ADD KEY `$$App$Price_Profiles` (`$$App$Price_Profiles`);

--
-- Indexes for table `Price_Profile_Item`
--
ALTER TABLE `Price_Profile_Item`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Offer` (`$Offer`),
  ADD KEY `$TFH_Property` (`$TFH_Property`),
  ADD KEY `$TFH_Room` (`$TFH_Room`),
  ADD KEY `$TFH_Rate` (`$TFH_Rate`),
  ADD KEY `$Price_Profile` (`$Price_Profile`);

--
-- Indexes for table `Properties`
--
ALTER TABLE `Properties`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Owner` (`$Owner`),
  ADD KEY `Remote_Id` (`Remote_Id`),
  ADD KEY `$Contract` (`$Contract`),
  ADD KEY `$Address` (`$Address`),
  ADD KEY `$Content_Image` (`$Content_Image`),
  ADD KEY `$Property_Facil_Top` (`$Property_Facil_Top`),
  ADD KEY `$Property_Facil_Activities` (`$Property_Facil_Activities`),
  ADD KEY `$Property_Facil_Food_Drink` (`$Property_Facil_Food_Drink`),
  ADD KEY `$Property_Facil_Pool_And_Wellness` (`$Property_Facil_Pool_And_Wellness`),
  ADD KEY `$Property_Facil_Transport` (`$Property_Facil_Transport`),
  ADD KEY `$Property_Facil_Reception_Services` (`$Property_Facil_Reception_Services`),
  ADD KEY `$Property_Facil_Common_Areas` (`$Property_Facil_Common_Areas`),
  ADD KEY `$Property_Facil_Entertainment_And_Family_Services` (`$Property_Facil_Entertainment_And_Family_Services`),
  ADD KEY `$Property_Facil_Cleaning_Services` (`$Property_Facil_Cleaning_Services`),
  ADD KEY `$Property_Facil_Business_Facilities` (`$Property_Facil_Business_Facilities`),
  ADD KEY `$Property_Facil_General` (`$Property_Facil_General`),
  ADD KEY `$API_Managed_User` (`$API_Managed_User`),
  ADD KEY `$Price_Profile` (`$Price_Profile`),
  ADD KEY `$Logo` (`$Logo`),
  ADD KEY `$Property_Stats` (`$Property_Stats`),
  ADD KEY `$$App$Properties` (`$$App$Properties`);

--
-- Indexes for table `Properties_Access`
--
ALTER TABLE `Properties_Access`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Access` (`$Access`),
  ADD KEY `$Properties` (`$Properties`);

--
-- Indexes for table `Properties_Age_Intervals`
--
ALTER TABLE `Properties_Age_Intervals`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Properties` (`$Properties`),
  ADD KEY `$none` (`$none`);

--
-- Indexes for table `Properties_Content_Images`
--
ALTER TABLE `Properties_Content_Images`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Properties` (`$Properties`),
  ADD KEY `$Content_Images` (`$Content_Images`);

--
-- Indexes for table `Properties_Content_Video_Embeds`
--
ALTER TABLE `Properties_Content_Video_Embeds`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Properties` (`$Properties`),
  ADD KEY `$Content_Video_Embeds` (`$Content_Video_Embeds`);

--
-- Indexes for table `Properties_Languages_Spoken`
--
ALTER TABLE `Properties_Languages_Spoken`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Properties` (`$Properties`),
  ADD KEY `$Languages_Spoken` (`$Languages_Spoken`);

--
-- Indexes for table `Properties_Rooms`
--
ALTER TABLE `Properties_Rooms`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Property` (`$Property`),
  ADD KEY `Remote_Id` (`Remote_Id`),
  ADD KEY `$Occupancy` (`$Occupancy`),
  ADD KEY `$Property_Room_Facil_Top` (`$Property_Room_Facil_Top`),
  ADD KEY `$Property_Room_Facil_Other` (`$Property_Room_Facil_Other`),
  ADD KEY `$Extra_Beds_Limits` (`$Extra_Beds_Limits`),
  ADD KEY `$Occupancy_Enforcement` (`$Occupancy_Enforcement`),
  ADD KEY `$Beds_Enforcement` (`$Beds_Enforcement`),
  ADD KEY `$Special_Deal` (`$Special_Deal`),
  ADD KEY `$App_Properties_Rooms` (`$App_Properties_Rooms`),
  ADD KEY `$Room_Availability_Stats` (`$Room_Availability_Stats`);

--
-- Indexes for table `Properties_Rooms_Beds`
--
ALTER TABLE `Properties_Rooms_Beds`
  ADD PRIMARY KEY (`$id`);

--
-- Indexes for table `Properties_Rooms_Content_Images`
--
ALTER TABLE `Properties_Rooms_Content_Images`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Properties_Rooms` (`$Properties_Rooms`),
  ADD KEY `$Content_Images` (`$Content_Images`);

--
-- Indexes for table `Properties_Rooms_Content_Video_Embeds`
--
ALTER TABLE `Properties_Rooms_Content_Video_Embeds`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Properties_Rooms` (`$Properties_Rooms`),
  ADD KEY `$Content_Video_Embeds` (`$Content_Video_Embeds`);

--
-- Indexes for table `Properties_Rooms_Extra_Beds_Limits_Per_Room`
--
ALTER TABLE `Properties_Rooms_Extra_Beds_Limits_Per_Room`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Properties_Rooms` (`$Properties_Rooms`),
  ADD KEY `$Extra_Beds_Limits_Per_Room` (`$Extra_Beds_Limits_Per_Room`);

--
-- Indexes for table `Properties_Rooms_Property_Room_Beds`
--
ALTER TABLE `Properties_Rooms_Property_Room_Beds`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Properties_Rooms` (`$Properties_Rooms`),
  ADD KEY `$Property_Room_Beds` (`$Property_Room_Beds`);

--
-- Indexes for table `Properties_Services`
--
ALTER TABLE `Properties_Services`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Properties` (`$Properties`),
  ADD KEY `$none` (`$none`);

--
-- Indexes for table `Properties_Stats`
--
ALTER TABLE `Properties_Stats`
  ADD PRIMARY KEY (`$id`);

--
-- Indexes for table `Properties_Store_Locations`
--
ALTER TABLE `Properties_Store_Locations`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Property` (`$Property`),
  ADD KEY `$Store_Location` (`$Store_Location`);

--
-- Indexes for table `Property_Contracts`
--
ALTER TABLE `Property_Contracts`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Contract_Upload_User` (`$Contract_Upload_User`);

--
-- Indexes for table `Property_Facil_Activities`
--
ALTER TABLE `Property_Facil_Activities`
  ADD PRIMARY KEY (`$id`);

--
-- Indexes for table `Property_Facil_Business_Facilities`
--
ALTER TABLE `Property_Facil_Business_Facilities`
  ADD PRIMARY KEY (`$id`);

--
-- Indexes for table `Property_Facil_Cleaning_Services`
--
ALTER TABLE `Property_Facil_Cleaning_Services`
  ADD PRIMARY KEY (`$id`);

--
-- Indexes for table `Property_Facil_Common_Areas`
--
ALTER TABLE `Property_Facil_Common_Areas`
  ADD PRIMARY KEY (`$id`);

--
-- Indexes for table `Property_Facil_Entertainment_And_Family_Services`
--
ALTER TABLE `Property_Facil_Entertainment_And_Family_Services`
  ADD PRIMARY KEY (`$id`);

--
-- Indexes for table `Property_Facil_Food_Drink`
--
ALTER TABLE `Property_Facil_Food_Drink`
  ADD PRIMARY KEY (`$id`);

--
-- Indexes for table `Property_Facil_General`
--
ALTER TABLE `Property_Facil_General`
  ADD PRIMARY KEY (`$id`);

--
-- Indexes for table `Property_Facil_Pool_And_Wellness`
--
ALTER TABLE `Property_Facil_Pool_And_Wellness`
  ADD PRIMARY KEY (`$id`);

--
-- Indexes for table `Property_Facil_Reception_Services`
--
ALTER TABLE `Property_Facil_Reception_Services`
  ADD PRIMARY KEY (`$id`);

--
-- Indexes for table `Property_Facil_Top`
--
ALTER TABLE `Property_Facil_Top`
  ADD PRIMARY KEY (`$id`);

--
-- Indexes for table `Property_Facil_Transport`
--
ALTER TABLE `Property_Facil_Transport`
  ADD PRIMARY KEY (`$id`);

--
-- Indexes for table `Property_Rooms_Availability_Stats`
--
ALTER TABLE `Property_Rooms_Availability_Stats`
  ADD PRIMARY KEY (`$id`);

--
-- Indexes for table `Property_Rooms_Availability_Stats_Has_Prices_Interval`
--
ALTER TABLE `Property_Rooms_Availability_Stats_Has_Prices_Interval`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Property_Rooms_Availability_Stats` (`$Property_Rooms_Availability_Stats`);

--
-- Indexes for table `Property_Rooms_Availability_Stats_No_Prices_Interval`
--
ALTER TABLE `Property_Rooms_Availability_Stats_No_Prices_Interval`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Property_Rooms_Availability_Stats` (`$Property_Rooms_Availability_Stats`),
  ADD KEY `$No_Prices_Interval` (`$No_Prices_Interval`);

--
-- Indexes for table `Property_Room_Facil_Other`
--
ALTER TABLE `Property_Room_Facil_Other`
  ADD PRIMARY KEY (`$id`);

--
-- Indexes for table `Property_Room_Facil_Top`
--
ALTER TABLE `Property_Room_Facil_Top`
  ADD PRIMARY KEY (`$id`);

--
-- Indexes for table `Rate_Plans`
--
ALTER TABLE `Rate_Plans`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `Remote_Id` (`Remote_Id`),
  ADD KEY `$Meal_Service` (`$Meal_Service`),
  ADD KEY `$Occupancy` (`$Occupancy`),
  ADD KEY `$Restrictions` (`$Restrictions`),
  ADD KEY `$Cancellation_Policy` (`$Cancellation_Policy`),
  ADD KEY `$Payment_Policy` (`$Payment_Policy`),
  ADD KEY `$Owner` (`$Owner`),
  ADD KEY `$Special_Deals$TFH_Rate_Plans` (`$Special_Deals$TFH_Rate_Plans`),
  ADD KEY `$$App$Rate_Plans` (`$$App$Rate_Plans`);

--
-- Indexes for table `Rate_Plans_Extra_Services`
--
ALTER TABLE `Rate_Plans_Extra_Services`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Rate_Plans` (`$Rate_Plans`),
  ADD KEY `$Extra_Services` (`$Extra_Services`);

--
-- Indexes for table `Rate_Plan_Access`
--
ALTER TABLE `Rate_Plan_Access`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Rate` (`$Rate`),
  ADD KEY `$Property` (`$Property`),
  ADD KEY `$Channel` (`$Channel`);

--
-- Indexes for table `Rate_Plan_Extra_Service`
--
ALTER TABLE `Rate_Plan_Extra_Service`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `Remote_Id` (`Remote_Id`),
  ADD KEY `$Offer` (`$Offer`);

--
-- Indexes for table `Rate_Plan_Room`
--
ALTER TABLE `Rate_Plan_Room`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Rate_Plan` (`$Rate_Plan`),
  ADD KEY `$Room` (`$Room`);

--
-- Indexes for table `Rate_Set_Requests`
--
ALTER TABLE `Rate_Set_Requests`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$$App$Rate_Set_Requests` (`$$App$Rate_Set_Requests`),
  ADD KEY `$Room` (`$Room`),
  ADD KEY `$Rate_Plan` (`$Rate_Plan`),
  ADD KEY `$Restrictions` (`$Restrictions`),
  ADD KEY `$Season` (`$Season`);

--
-- Indexes for table `Registration_Requests`
--
ALTER TABLE `Registration_Requests`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$$App$Registration_Requests` (`$$App$Registration_Requests`),
  ADD KEY `$Company` (`$Company`),
  ADD KEY `$User` (`$User`);

--
-- Indexes for table `Request_Logs`
--
ALTER TABLE `Request_Logs`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `Date` (`Date`),
  ADD KEY `IP_v4` (`IP_v4`),
  ADD KEY `Request_URI` (`Request_URI`),
  ADD KEY `Session_Id` (`Session_Id`),
  ADD KEY `User_Agent` (`User_Agent`),
  ADD KEY `$$App$Request_Logs` (`$$App$Request_Logs`);

--
-- Indexes for table `Request_Logs_Traces`
--
ALTER TABLE `Request_Logs_Traces`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Request` (`$Request`),
  ADD KEY `Tags` (`Tags`(1024));

--
-- Indexes for table `Restrictions`
--
ALTER TABLE `Restrictions`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Owner` (`$Owner`),
  ADD KEY `$$App$Restrictions` (`$$App$Restrictions`);

--
-- Indexes for table `Reverse_APIs`
--
ALTER TABLE `Reverse_APIs`
  ADD PRIMARY KEY (`$id`);

--
-- Indexes for table `Reverse_APIs_Items`
--
ALTER TABLE `Reverse_APIs_Items`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Reverse_APIs` (`$Reverse_APIs`),
  ADD KEY `$Items` (`$Items`);

--
-- Indexes for table `Rooms_Occupancy_Beds_Setup`
--
ALTER TABLE `Rooms_Occupancy_Beds_Setup`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Occupancy` (`$Occupancy`);

--
-- Indexes for table `Rooms_Occupancy_Beds_Setup_Age_Intervals`
--
ALTER TABLE `Rooms_Occupancy_Beds_Setup_Age_Intervals`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Rooms_Occupancy_Beds_Setup` (`$Rooms_Occupancy_Beds_Setup`);

--
-- Indexes for table `Room_Occupancies`
--
ALTER TABLE `Room_Occupancies`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `Remote_Id` (`Remote_Id`),
  ADD KEY `$Infant_Limits` (`$Infant_Limits`),
  ADD KEY `$Toddler_Limits` (`$Toddler_Limits`),
  ADD KEY `$Child_Limits` (`$Child_Limits`),
  ADD KEY `$Adolescent_Limits` (`$Adolescent_Limits`),
  ADD KEY `$Adult_Limits` (`$Adult_Limits`),
  ADD KEY `$Owner` (`$Owner`),
  ADD KEY `$$App$Room_Occupancies` (`$$App$Room_Occupancies`);

--
-- Indexes for table `Room_Occupancies_Occupancy_Pricing`
--
ALTER TABLE `Room_Occupancies_Occupancy_Pricing`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Room_Occupancies` (`$Room_Occupancies`),
  ADD KEY `$Occupancy_Pricing` (`$Occupancy_Pricing`);

--
-- Indexes for table `Room_Occupancy_Limits`
--
ALTER TABLE `Room_Occupancy_Limits`
  ADD PRIMARY KEY (`$id`);

--
-- Indexes for table `Room_Occupancy_Pricing`
--
ALTER TABLE `Room_Occupancy_Pricing`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Property` (`$Property`),
  ADD KEY `$Rate_Plan` (`$Rate_Plan`),
  ADD KEY `$Combination_Of` (`$Combination_Of`),
  ADD KEY `$Relative_To` (`$Relative_To`),
  ADD KEY `$$App$Room_Occupancy_Pricing` (`$$App$Room_Occupancy_Pricing`);

--
-- Indexes for table `Room_Occupants`
--
ALTER TABLE `Room_Occupants`
  ADD PRIMARY KEY (`$id`);

--
-- Indexes for table `Room_Order_Item_Configs`
--
ALTER TABLE `Room_Order_Item_Configs`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Property` (`$Property`),
  ADD KEY `$Room` (`$Room`),
  ADD KEY `$Rate_Plan` (`$Rate_Plan`),
  ADD KEY `$Restrictions` (`$Restrictions`),
  ADD KEY `$Occupancy` (`$Occupancy`);

--
-- Indexes for table `Room_Order_Item_Configs_Extra_Services`
--
ALTER TABLE `Room_Order_Item_Configs_Extra_Services`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Room_Order_Item_Configs` (`$Room_Order_Item_Configs`),
  ADD KEY `$Extra_Services` (`$Extra_Services`);

--
-- Indexes for table `Room_Order_Item_Configs_Nights_Costs`
--
ALTER TABLE `Room_Order_Item_Configs_Nights_Costs`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Room_Order_Item_Configs` (`$Room_Order_Item_Configs`);

--
-- Indexes for table `Room_Order_Item_Configs_Occupants`
--
ALTER TABLE `Room_Order_Item_Configs_Occupants`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Room_Order_Item_Configs` (`$Room_Order_Item_Configs`),
  ADD KEY `$Occupants` (`$Occupants`);

--
-- Indexes for table `Search_Locations`
--
ALTER TABLE `Search_Locations`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$$App$Search_Locations` (`$$App$Search_Locations`);

--
-- Indexes for table `Search_Locations_Addresses`
--
ALTER TABLE `Search_Locations_Addresses`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Search_Locations` (`$Search_Locations`),
  ADD KEY `$Addresses` (`$Addresses`);

--
-- Indexes for table `Search_Offers`
--
ALTER TABLE `Search_Offers`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Country` (`$Country`),
  ADD KEY `$Property_Facil_Top` (`$Property_Facil_Top`),
  ADD KEY `$Property_Room_Facil_Top` (`$Property_Room_Facil_Top`),
  ADD KEY `$Channel_Corporate_Code` (`$Channel_Corporate_Code`),
  ADD KEY `$Property_Corporate_Code` (`$Property_Corporate_Code`);

--
-- Indexes for table `Search_Offers_Available_Rooms`
--
ALTER TABLE `Search_Offers_Available_Rooms`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Search_Offers` (`$Search_Offers`);

--
-- Indexes for table `Search_Offers_Cancellation_Policy_Text`
--
ALTER TABLE `Search_Offers_Cancellation_Policy_Text`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Search_Offers` (`$Search_Offers`);

--
-- Indexes for table `Search_Offers_Cities`
--
ALTER TABLE `Search_Offers_Cities`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Search_Offers` (`$Search_Offers`),
  ADD KEY `$Cities` (`$Cities`);

--
-- Indexes for table `Search_Offers_Contract_Was_Signed`
--
ALTER TABLE `Search_Offers_Contract_Was_Signed`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Search_Offers` (`$Search_Offers`);

--
-- Indexes for table `Search_Offers_Facility`
--
ALTER TABLE `Search_Offers_Facility`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Search_Offers` (`$Search_Offers`);

--
-- Indexes for table `Search_Offers_Has_Corporate_Code`
--
ALTER TABLE `Search_Offers_Has_Corporate_Code`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Search_Offers` (`$Search_Offers`);

--
-- Indexes for table `Search_Offers_Meal`
--
ALTER TABLE `Search_Offers_Meal`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Search_Offers` (`$Search_Offers`);

--
-- Indexes for table `Search_Offers_Missing_Contract`
--
ALTER TABLE `Search_Offers_Missing_Contract`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Search_Offers` (`$Search_Offers`);

--
-- Indexes for table `Search_Offers_Payment_Policy_Text`
--
ALTER TABLE `Search_Offers_Payment_Policy_Text`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Search_Offers` (`$Search_Offers`);

--
-- Indexes for table `Search_Offers_Properties`
--
ALTER TABLE `Search_Offers_Properties`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Search_Offers` (`$Search_Offers`),
  ADD KEY `$Properties` (`$Properties`);

--
-- Indexes for table `Search_Offers_Property_Type`
--
ALTER TABLE `Search_Offers_Property_Type`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Search_Offers` (`$Search_Offers`);

--
-- Indexes for table `Search_Offers_Rooms_Count`
--
ALTER TABLE `Search_Offers_Rooms_Count`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Search_Offers` (`$Search_Offers`);

--
-- Indexes for table `Search_Offers_Room_Facility`
--
ALTER TABLE `Search_Offers_Room_Facility`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Search_Offers` (`$Search_Offers`);

--
-- Indexes for table `Search_Offers_Stars`
--
ALTER TABLE `Search_Offers_Stars`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Search_Offers` (`$Search_Offers`);

--
-- Indexes for table `Search_Rooms`
--
ALTER TABLE `Search_Rooms`
  ADD PRIMARY KEY (`$id`);

--
-- Indexes for table `Seasons`
--
ALTER TABLE `Seasons`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Owner` (`$Owner`),
  ADD KEY `$$App$Seasons` (`$$App$Seasons`);

--
-- Indexes for table `Seasons_Season_Time`
--
ALTER TABLE `Seasons_Season_Time`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Seasons` (`$Seasons`),
  ADD KEY `$Season_Time` (`$Season_Time`);

--
-- Indexes for table `Season_Time`
--
ALTER TABLE `Season_Time`
  ADD PRIMARY KEY (`$id`);

--
-- Indexes for table `Seo_Images`
--
ALTER TABLE `Seo_Images`
  ADD PRIMARY KEY (`$id`);

--
-- Indexes for table `Seo_Video_Embed`
--
ALTER TABLE `Seo_Video_Embed`
  ADD PRIMARY KEY (`$id`);

--
-- Indexes for table `Services_Calendar`
--
ALTER TABLE `Services_Calendar`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Owner` (`$Owner`),
  ADD KEY `$$App$Services_Calendar` (`$$App$Services_Calendar`);

--
-- Indexes for table `Services_Calendar_Dates`
--
ALTER TABLE `Services_Calendar_Dates`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Calendar` (`$Calendar`);

--
-- Indexes for table `Sessions`
--
ALTER TABLE `Sessions`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `SessionId` (`SessionId`);

--
-- Indexes for table `Sessions_Data_`
--
ALTER TABLE `Sessions_Data_`
  ADD PRIMARY KEY (`$id`),
  ADD UNIQUE KEY `Session_Id` (`Session_Id`),
  ADD KEY `IP` (`IP`),
  ADD KEY `C_Time` (`C_Time`),
  ADD KEY `M_Time` (`M_Time`),
  ADD KEY `A_Time` (`A_Time`);

--
-- Indexes for table `Special_Deals`
--
ALTER TABLE `Special_Deals`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Special_Offer` (`$Special_Offer`),
  ADD KEY `$Property` (`$Property`),
  ADD KEY `$Owner` (`$Owner`),
  ADD KEY `$$App$Special_Deals` (`$$App$Special_Deals`);

--
-- Indexes for table `Special_Deals_TFH_Rooms`
--
ALTER TABLE `Special_Deals_TFH_Rooms`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Special_Deals` (`$Special_Deals`),
  ADD KEY `$TFH_Rooms` (`$TFH_Rooms`);

--
-- Indexes for table `Special_Offer_Deal`
--
ALTER TABLE `Special_Offer_Deal`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Payment_Policy` (`$Payment_Policy`),
  ADD KEY `$Cancellation_Policy` (`$Cancellation_Policy`);

--
-- Indexes for table `Store_Locations`
--
ALTER TABLE `Store_Locations`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$App_Store_Locations` (`$App_Store_Locations`);

--
-- Indexes for table `Store_Locations_Addresses`
--
ALTER TABLE `Store_Locations_Addresses`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Store_Locations` (`$Store_Locations`),
  ADD KEY `$Addresses` (`$Addresses`);

--
-- Indexes for table `Terms_And_Conditions_Pages`
--
ALTER TABLE `Terms_And_Conditions_Pages`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$$App$Terms_And_Conditions_Pages` (`$$App$Terms_And_Conditions_Pages`),
  ADD KEY `$$App$Privacy_Policy_Pages` (`$$App$Privacy_Policy_Pages`);

--
-- Indexes for table `Texts`
--
ALTER TABLE `Texts`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$$App$Texts` (`$$App$Texts`),
  ADD KEY `Key` (`Key`);

--
-- Indexes for table `TFH_Offer`
--
ALTER TABLE `TFH_Offer`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Property` (`$Property`),
  ADD KEY `$Property_Room` (`$Property_Room`),
  ADD KEY `$Rate_Plan` (`$Rate_Plan`),
  ADD KEY `$Meal` (`$Meal`);

--
-- Indexes for table `TFH_Offer_Cancellation_Policy`
--
ALTER TABLE `TFH_Offer_Cancellation_Policy`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$TFH_Offer` (`$TFH_Offer`);

--
-- Indexes for table `TFH_Offer_Extra_Services`
--
ALTER TABLE `TFH_Offer_Extra_Services`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$TFH_Offer` (`$TFH_Offer`),
  ADD KEY `$Extra_Services` (`$Extra_Services`);

--
-- Indexes for table `TFH_Offer_Occupants`
--
ALTER TABLE `TFH_Offer_Occupants`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$TFH_Offer` (`$TFH_Offer`),
  ADD KEY `$Occupants` (`$Occupants`);

--
-- Indexes for table `TFH_Offer_Payment_Policy`
--
ALTER TABLE `TFH_Offer_Payment_Policy`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$TFH_Offer` (`$TFH_Offer`);

--
-- Indexes for table `User_Access_Templates`
--
ALTER TABLE `User_Access_Templates`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Owner` (`$Owner`),
  ADD KEY `$$App$User_Access_Templates` (`$$App$User_Access_Templates`);

--
-- Indexes for table `User_Access_Templates_Properties`
--
ALTER TABLE `User_Access_Templates_Properties`
  ADD PRIMARY KEY (`$id`),
  ADD KEY `$Properties` (`$Properties`),
  ADD KEY `$User_Access_Templates` (`$User_Access_Templates`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `$App`
--
ALTER TABLE `$App`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `$GroupRelations`
--
ALTER TABLE `$GroupRelations`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `$GroupRelations_Groups`
--
ALTER TABLE `$GroupRelations_Groups`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `$UserGroups`
--
ALTER TABLE `$UserGroups`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `$UserGroups_Groups`
--
ALTER TABLE `$UserGroups_Groups`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `$UserGroups_Relations`
--
ALTER TABLE `$UserGroups_Relations`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `$Users`
--
ALTER TABLE `$Users`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `$UsersGroupsList`
--
ALTER TABLE `$UsersGroupsList`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `$Users_Access`
--
ALTER TABLE `$Users_Access`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `$Users_Authorized_IPs`
--
ALTER TABLE `$Users_Authorized_IPs`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `$Users_Notifications`
--
ALTER TABLE `$Users_Notifications`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Account_Configurations`
--
ALTER TABLE `Account_Configurations`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Addresses`
--
ALTER TABLE `Addresses`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Age_Intervals`
--
ALTER TABLE `Age_Intervals`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `API_Systems`
--
ALTER TABLE `API_Systems`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Bank_Accounts`
--
ALTER TABLE `Bank_Accounts`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `BNR_Rates`
--
ALTER TABLE `BNR_Rates`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Cache_View`
--
ALTER TABLE `Cache_View`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Cancellation_Policies`
--
ALTER TABLE `Cancellation_Policies`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Cancellation_Policies_Items`
--
ALTER TABLE `Cancellation_Policies_Items`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Channel_Contract`
--
ALTER TABLE `Channel_Contract`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Channel_Corporate_Codes`
--
ALTER TABLE `Channel_Corporate_Codes`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Checkout_Orders`
--
ALTER TABLE `Checkout_Orders`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Checkout_Orders_Offers`
--
ALTER TABLE `Checkout_Orders_Offers`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Cities`
--
ALTER TABLE `Cities`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Cities_TFH_Search_Cities`
--
ALTER TABLE `Cities_TFH_Search_Cities`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Cities_TFH_Search_Properties`
--
ALTER TABLE `Cities_TFH_Search_Properties`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Companies`
--
ALTER TABLE `Companies`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Companies_Accessible_By`
--
ALTER TABLE `Companies_Accessible_By`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Companies_Api_IPs`
--
ALTER TABLE `Companies_Api_IPs`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Companies_Bank_Accounts`
--
ALTER TABLE `Companies_Bank_Accounts`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Companies_Contacts`
--
ALTER TABLE `Companies_Contacts`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Companies_Contact_Emails_List`
--
ALTER TABLE `Companies_Contact_Emails_List`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Companies_Contact_Phones_List`
--
ALTER TABLE `Companies_Contact_Phones_List`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Companies_Emails_List`
--
ALTER TABLE `Companies_Emails_List`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Companies_Phones_List`
--
ALTER TABLE `Companies_Phones_List`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Contact_Information`
--
ALTER TABLE `Contact_Information`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Content`
--
ALTER TABLE `Content`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Corporate_Codes`
--
ALTER TABLE `Corporate_Codes`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Corporate_Codes_Accessible_To`
--
ALTER TABLE `Corporate_Codes_Accessible_To`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Corporate_Codes_Rate_Plans`
--
ALTER TABLE `Corporate_Codes_Rate_Plans`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Counties`
--
ALTER TABLE `Counties`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Countries`
--
ALTER TABLE `Countries`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Dates_Intervals`
--
ALTER TABLE `Dates_Intervals`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Dates_Intervals_End_Date`
--
ALTER TABLE `Dates_Intervals_End_Date`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Dates_Intervals_Start_Date`
--
ALTER TABLE `Dates_Intervals_Start_Date`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Date_Room`
--
ALTER TABLE `Date_Room`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Date_Room_Rate`
--
ALTER TABLE `Date_Room_Rate`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Date_Room_Rates`
--
ALTER TABLE `Date_Room_Rates`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Documents`
--
ALTER TABLE `Documents`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `DRR_Logs`
--
ALTER TABLE `DRR_Logs`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Emails_Sent`
--
ALTER TABLE `Emails_Sent`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Extra_Beds_Limits`
--
ALTER TABLE `Extra_Beds_Limits`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `FailedLogins`
--
ALTER TABLE `FailedLogins`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Favorite_Orders`
--
ALTER TABLE `Favorite_Orders`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Favorite_Orders_Favorite_Offers`
--
ALTER TABLE `Favorite_Orders_Favorite_Offers`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Favorite_Order_Email`
--
ALTER TABLE `Favorite_Order_Email`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Favorite_Order_Email_Emails`
--
ALTER TABLE `Favorite_Order_Email_Emails`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Favorite_Order_Email_Favorite_Offers`
--
ALTER TABLE `Favorite_Order_Email_Favorite_Offers`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `General_Properties_Facilities`
--
ALTER TABLE `General_Properties_Facilities`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `General_Properties_Room_Facilities`
--
ALTER TABLE `General_Properties_Room_Facilities`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Identities`
--
ALTER TABLE `Identities`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Invoices`
--
ALTER TABLE `Invoices`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Invoices_Collected`
--
ALTER TABLE `Invoices_Collected`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Invoices_Items`
--
ALTER TABLE `Invoices_Items`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Invoices_Orders`
--
ALTER TABLE `Invoices_Orders`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Invoices_Series`
--
ALTER TABLE `Invoices_Series`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Invoices_VAT_Rates`
--
ALTER TABLE `Invoices_VAT_Rates`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Invoice_Payment_Types`
--
ALTER TABLE `Invoice_Payment_Types`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Key_Value`
--
ALTER TABLE `Key_Value`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Languages`
--
ALTER TABLE `Languages`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `List_Offers`
--
ALTER TABLE `List_Offers`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `LoginLog`
--
ALTER TABLE `LoginLog`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Mails_Senders`
--
ALTER TABLE `Mails_Senders`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Mails_Senders_ReplyTo`
--
ALTER TABLE `Mails_Senders_ReplyTo`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Notifications`
--
ALTER TABLE `Notifications`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Offers`
--
ALTER TABLE `Offers`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Offers_Bundle_Items`
--
ALTER TABLE `Offers_Bundle_Items`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Offer_Category`
--
ALTER TABLE `Offer_Category`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Offer_Discount`
--
ALTER TABLE `Offer_Discount`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Offer_Enforcements`
--
ALTER TABLE `Offer_Enforcements`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Offer_Enforcements_Offer_Enforcement_Items`
--
ALTER TABLE `Offer_Enforcements_Offer_Enforcement_Items`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Offer_Enforcement_Items`
--
ALTER TABLE `Offer_Enforcement_Items`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Orders`
--
ALTER TABLE `Orders`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Orders_Documents`
--
ALTER TABLE `Orders_Documents`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Orders_Emails_Sent`
--
ALTER TABLE `Orders_Emails_Sent`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Orders_Items`
--
ALTER TABLE `Orders_Items`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Orders_Reverse_Api_Log`
--
ALTER TABLE `Orders_Reverse_Api_Log`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Payment_Policies`
--
ALTER TABLE `Payment_Policies`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Payment_Policies_Items`
--
ALTER TABLE `Payment_Policies_Items`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Payment_Policy_Items`
--
ALTER TABLE `Payment_Policy_Items`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Persons`
--
ALTER TABLE `Persons`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Price_Profile`
--
ALTER TABLE `Price_Profile`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Price_Profile_Item`
--
ALTER TABLE `Price_Profile_Item`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Properties`
--
ALTER TABLE `Properties`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Properties_Access`
--
ALTER TABLE `Properties_Access`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Properties_Age_Intervals`
--
ALTER TABLE `Properties_Age_Intervals`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Properties_Content_Images`
--
ALTER TABLE `Properties_Content_Images`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Properties_Content_Video_Embeds`
--
ALTER TABLE `Properties_Content_Video_Embeds`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Properties_Languages_Spoken`
--
ALTER TABLE `Properties_Languages_Spoken`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Properties_Rooms`
--
ALTER TABLE `Properties_Rooms`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Properties_Rooms_Beds`
--
ALTER TABLE `Properties_Rooms_Beds`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Properties_Rooms_Content_Images`
--
ALTER TABLE `Properties_Rooms_Content_Images`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Properties_Rooms_Content_Video_Embeds`
--
ALTER TABLE `Properties_Rooms_Content_Video_Embeds`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Properties_Rooms_Extra_Beds_Limits_Per_Room`
--
ALTER TABLE `Properties_Rooms_Extra_Beds_Limits_Per_Room`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Properties_Rooms_Property_Room_Beds`
--
ALTER TABLE `Properties_Rooms_Property_Room_Beds`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Properties_Services`
--
ALTER TABLE `Properties_Services`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Properties_Stats`
--
ALTER TABLE `Properties_Stats`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Properties_Store_Locations`
--
ALTER TABLE `Properties_Store_Locations`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Property_Contracts`
--
ALTER TABLE `Property_Contracts`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Property_Facil_Activities`
--
ALTER TABLE `Property_Facil_Activities`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Property_Facil_Business_Facilities`
--
ALTER TABLE `Property_Facil_Business_Facilities`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Property_Facil_Cleaning_Services`
--
ALTER TABLE `Property_Facil_Cleaning_Services`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Property_Facil_Common_Areas`
--
ALTER TABLE `Property_Facil_Common_Areas`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Property_Facil_Entertainment_And_Family_Services`
--
ALTER TABLE `Property_Facil_Entertainment_And_Family_Services`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Property_Facil_Food_Drink`
--
ALTER TABLE `Property_Facil_Food_Drink`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Property_Facil_General`
--
ALTER TABLE `Property_Facil_General`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Property_Facil_Pool_And_Wellness`
--
ALTER TABLE `Property_Facil_Pool_And_Wellness`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Property_Facil_Reception_Services`
--
ALTER TABLE `Property_Facil_Reception_Services`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Property_Facil_Top`
--
ALTER TABLE `Property_Facil_Top`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Property_Facil_Transport`
--
ALTER TABLE `Property_Facil_Transport`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Property_Rooms_Availability_Stats`
--
ALTER TABLE `Property_Rooms_Availability_Stats`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Property_Rooms_Availability_Stats_Has_Prices_Interval`
--
ALTER TABLE `Property_Rooms_Availability_Stats_Has_Prices_Interval`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Property_Rooms_Availability_Stats_No_Prices_Interval`
--
ALTER TABLE `Property_Rooms_Availability_Stats_No_Prices_Interval`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Property_Room_Facil_Other`
--
ALTER TABLE `Property_Room_Facil_Other`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Property_Room_Facil_Top`
--
ALTER TABLE `Property_Room_Facil_Top`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Rate_Plans`
--
ALTER TABLE `Rate_Plans`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Rate_Plans_Extra_Services`
--
ALTER TABLE `Rate_Plans_Extra_Services`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Rate_Plan_Access`
--
ALTER TABLE `Rate_Plan_Access`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Rate_Plan_Extra_Service`
--
ALTER TABLE `Rate_Plan_Extra_Service`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Rate_Plan_Room`
--
ALTER TABLE `Rate_Plan_Room`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Rate_Set_Requests`
--
ALTER TABLE `Rate_Set_Requests`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Registration_Requests`
--
ALTER TABLE `Registration_Requests`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Request_Logs`
--
ALTER TABLE `Request_Logs`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Request_Logs_Traces`
--
ALTER TABLE `Request_Logs_Traces`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Restrictions`
--
ALTER TABLE `Restrictions`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Reverse_APIs`
--
ALTER TABLE `Reverse_APIs`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Reverse_APIs_Items`
--
ALTER TABLE `Reverse_APIs_Items`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Rooms_Occupancy_Beds_Setup`
--
ALTER TABLE `Rooms_Occupancy_Beds_Setup`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Rooms_Occupancy_Beds_Setup_Age_Intervals`
--
ALTER TABLE `Rooms_Occupancy_Beds_Setup_Age_Intervals`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Room_Occupancies`
--
ALTER TABLE `Room_Occupancies`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Room_Occupancies_Occupancy_Pricing`
--
ALTER TABLE `Room_Occupancies_Occupancy_Pricing`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Room_Occupancy_Limits`
--
ALTER TABLE `Room_Occupancy_Limits`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Room_Occupancy_Pricing`
--
ALTER TABLE `Room_Occupancy_Pricing`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Room_Occupants`
--
ALTER TABLE `Room_Occupants`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Room_Order_Item_Configs`
--
ALTER TABLE `Room_Order_Item_Configs`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Room_Order_Item_Configs_Extra_Services`
--
ALTER TABLE `Room_Order_Item_Configs_Extra_Services`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Room_Order_Item_Configs_Nights_Costs`
--
ALTER TABLE `Room_Order_Item_Configs_Nights_Costs`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Room_Order_Item_Configs_Occupants`
--
ALTER TABLE `Room_Order_Item_Configs_Occupants`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Search_Locations`
--
ALTER TABLE `Search_Locations`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Search_Locations_Addresses`
--
ALTER TABLE `Search_Locations_Addresses`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Search_Offers`
--
ALTER TABLE `Search_Offers`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Search_Offers_Available_Rooms`
--
ALTER TABLE `Search_Offers_Available_Rooms`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Search_Offers_Cancellation_Policy_Text`
--
ALTER TABLE `Search_Offers_Cancellation_Policy_Text`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Search_Offers_Cities`
--
ALTER TABLE `Search_Offers_Cities`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Search_Offers_Contract_Was_Signed`
--
ALTER TABLE `Search_Offers_Contract_Was_Signed`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Search_Offers_Facility`
--
ALTER TABLE `Search_Offers_Facility`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Search_Offers_Has_Corporate_Code`
--
ALTER TABLE `Search_Offers_Has_Corporate_Code`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Search_Offers_Meal`
--
ALTER TABLE `Search_Offers_Meal`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Search_Offers_Missing_Contract`
--
ALTER TABLE `Search_Offers_Missing_Contract`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Search_Offers_Payment_Policy_Text`
--
ALTER TABLE `Search_Offers_Payment_Policy_Text`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Search_Offers_Properties`
--
ALTER TABLE `Search_Offers_Properties`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Search_Offers_Property_Type`
--
ALTER TABLE `Search_Offers_Property_Type`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Search_Offers_Rooms_Count`
--
ALTER TABLE `Search_Offers_Rooms_Count`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Search_Offers_Room_Facility`
--
ALTER TABLE `Search_Offers_Room_Facility`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Search_Offers_Stars`
--
ALTER TABLE `Search_Offers_Stars`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Search_Rooms`
--
ALTER TABLE `Search_Rooms`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Seasons`
--
ALTER TABLE `Seasons`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Seasons_Season_Time`
--
ALTER TABLE `Seasons_Season_Time`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Season_Time`
--
ALTER TABLE `Season_Time`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Seo_Images`
--
ALTER TABLE `Seo_Images`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Seo_Video_Embed`
--
ALTER TABLE `Seo_Video_Embed`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Services_Calendar`
--
ALTER TABLE `Services_Calendar`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Services_Calendar_Dates`
--
ALTER TABLE `Services_Calendar_Dates`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Sessions`
--
ALTER TABLE `Sessions`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Sessions_Data_`
--
ALTER TABLE `Sessions_Data_`
  MODIFY `$id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `Special_Deals`
--
ALTER TABLE `Special_Deals`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Special_Deals_TFH_Rooms`
--
ALTER TABLE `Special_Deals_TFH_Rooms`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Special_Offer_Deal`
--
ALTER TABLE `Special_Offer_Deal`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Store_Locations`
--
ALTER TABLE `Store_Locations`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Store_Locations_Addresses`
--
ALTER TABLE `Store_Locations_Addresses`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Terms_And_Conditions_Pages`
--
ALTER TABLE `Terms_And_Conditions_Pages`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `Texts`
--
ALTER TABLE `Texts`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `TFH_Offer`
--
ALTER TABLE `TFH_Offer`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `TFH_Offer_Cancellation_Policy`
--
ALTER TABLE `TFH_Offer_Cancellation_Policy`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `TFH_Offer_Extra_Services`
--
ALTER TABLE `TFH_Offer_Extra_Services`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `TFH_Offer_Occupants`
--
ALTER TABLE `TFH_Offer_Occupants`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `TFH_Offer_Payment_Policy`
--
ALTER TABLE `TFH_Offer_Payment_Policy`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `User_Access_Templates`
--
ALTER TABLE `User_Access_Templates`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';

--
-- AUTO_INCREMENT for table `User_Access_Templates_Properties`
--
ALTER TABLE `User_Access_Templates_Properties`
  MODIFY `$id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Id/RowId column role';
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
