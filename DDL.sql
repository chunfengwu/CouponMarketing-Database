-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema COUPON_MARKETING
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema COUPON_MARKETING
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `COUPON_MARKETING` DEFAULT CHARACTER SET latin1 ;
USE `COUPON_MARKETING` ;

-- -----------------------------------------------------
-- Table `COUPON_MARKETING`.`product_category`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `COUPON_MARKETING`.`product_category` (
  `Category_id` VARCHAR(45) NOT NULL,
  `Category_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Category_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `COUPON_MARKETING`.`product`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `COUPON_MARKETING`.`product` (
  `Product_id` VARCHAR(45) NOT NULL,
  `Price` FLOAT NOT NULL,
  `Category_id` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Product_id`),
  INDEX `fk_product_product_category1_idx` (`Category_id` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `COUPON_MARKETING`.`coupon`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `COUPON_MARKETING`.`coupon` (
  `Coupon_id` VARCHAR(8) NOT NULL,
  `Product_id` VARCHAR(8) NOT NULL,
  `Start_Time` DATETIME NOT NULL,
  `Expiration_Time` DATETIME NOT NULL,
  `Discount_Value` DOUBLE NOT NULL,
  `Total_Num_Used` INT(11) NOT NULL ,
  PRIMARY KEY (`Coupon_id`),
  INDEX `Product_ID_idx` (`Product_id` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `COUPON_MARKETING`.`customer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `COUPON_MARKETING`.`customer` (
  `Customer_id` BIGINT(20) NOT NULL ,
  `Customer_Name` TEXT NULL ,
  `Gender` TEXT NULL ,
  `Country` TEXT NULL ,
  `Street` TEXT NULL ,
  `City` TEXT NULL ,
  `State` TEXT NULL ,
  `Zip` INT(11) NULL ,
  `Phone` TEXT NULL ,
  `Email` TEXT NOT NULL ,
  `Credit_Card_Last4` INT(4) NULL ,
  `Num_Visits` INT NOT NULL ,
  `First_Visit` TEXT NOT NULL ,
  `Last_Visit` DATETIME NOT NULL ,
  PRIMARY KEY (`Customer_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `COUPON_MARKETING`.`ship_address`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `COUPON_MARKETING`.`ship_address` (
  `ShipAddress_id` INT(11) NOT NULL,
  `Country` TEXT NOT NULL,
  `Street_Ship` TEXT NOT NULL,
  `City_Ship` TEXT NOT NULL,
  `State_Ship` TEXT NOT NULL,
  `ZIP_Ship` INT(11) NOT NULL,
  PRIMARY KEY (`ShipAddress_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `COUPON_MARKETING`.`order`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `COUPON_MARKETING`.`order` (
  `Order_id` INT(11) NOT NULL,
  `Order_date` TEXT NOT NULL,
  `Order_status` TEXT NOT NULL,
  `Customer_id` BIGINT(20) NOT NULL,
  `Ship_Address_ID` INT(11) NOT NULL,
  PRIMARY KEY (`Order_id`),
  INDEX `Customer_id_idx` (`Customer_id` ASC),
  INDEX `Ship_Address_ID_idx` (`Ship_Address_ID` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `COUPON_MARKETING`.`size`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `COUPON_MARKETING`.`size` (
  `Size_id` INT NOT NULL,
  `US_size` FLOAT NOT NULL,
  `EK_size` FLOAT NOT NULL,
  PRIMARY KEY (`Size_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `COUPON_MARKETING`.`order_product_info`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `COUPON_MARKETING`.`order_product_info` (
  `Info_id` INT NOT NULL AUTO_INCREMENT,
  `Order_id` INT(11) NOT NULL,
  `Size_id` INT(2) NOT NULL,
  `Order_quantity` INT NOT NULL,
  `Product_id` VARCHAR(45) NOT NULL,
  `Coupon_id` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Info_id`),
  INDEX `Order_id_idx` (`Order_id` ASC),
  INDEX `Coupon_id_idx` (`Coupon_id` ASC),
  INDEX `Size_id_idx` (`Size_id` ASC),
  INDEX `Product_id_idx` (`Product_id` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'order_product_id';


-- -----------------------------------------------------
-- Table `COUPON_MARKETING`.`product_category`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `COUPON_MARKETING`.`product_category` (
  `Category_id` VARCHAR(45) NOT NULL,
  `Category_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Category_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `COUPON_MARKETING`.`inventory`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `COUPON_MARKETING`.`inventory` (
  `Stock_id` INT NOT NULL AUTO_INCREMENT,
  `Product_id` VARCHAR(45) NOT NULL,
  `Num_of_Stock` VARCHAR(45) NOT NULL,
  `Size_id` INT(2) NOT NULL,
  PRIMARY KEY (`Stock_id`),
  INDEX `Size_id_idx` (`Size_id` ASC),
  INDEX `Product_id_idx` (`Product_id` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `COUPON_MARKETING`.`product_category`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `COUPON_MARKETING`.`product_category` (
  `Category_id` VARCHAR(45) NOT NULL,
  `Category_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Category_id`))
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
