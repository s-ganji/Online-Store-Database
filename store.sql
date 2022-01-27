-- phpMyAdmin SQL Dump
-- version 4.7.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 21, 2019 at 04:52 AM
-- Server version: 10.1.26-MariaDB
-- PHP Version: 7.1.9

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `store`
--

-- --------------------------------------------------------

--
-- Table structure for table `bank_account`
--

CREATE TABLE `bank_account` (
  `ID` char(20) NOT NULL,
  `username` char(20) DEFAULT NULL,
  `bankCredit` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `bank_account`
--

INSERT INTO `bank_account` (`ID`, `username`, `bankCredit`) VALUES
('1', 'cu1', 1000000),
('2', 'cu2', 950000),
('3', 'cu3', 400000),
('4', 'cu4', 1550000),
('5', 'cu5', 1500000);

-- --------------------------------------------------------

--
-- Table structure for table `charging_credit`
--

CREATE TABLE `charging_credit` (
  `username` char(20) DEFAULT NULL,
  `chargingAmount` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `charging_credit`
--

INSERT INTO `charging_credit` (`username`, `chargingAmount`) VALUES
('cu3', 100000),
('cu2', 200000);

--
-- Triggers `charging_credit`
--
DELIMITER $$
CREATE TRIGGER `charging` AFTER INSERT ON `charging_credit` FOR EACH ROW BEGIN
UPDATE bank_account
SET bankCredit=bankCredit-NEW.chargingAmount
WHERE bank_account.username=NEW.username;

UPDATE old_customer
SET credit=credit+NEW.chargingAmount
WHERE old_customer.username=NEW.username;

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `conversation`
--

CREATE TABLE `conversation` (
  `customer_username` char(20) DEFAULT NULL,
  `order_id` char(20) DEFAULT NULL,
  `message` longtext
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `conversation`
--

INSERT INTO `conversation` (`customer_username`, `order_id`, `message`) VALUES
('cu1', 'or1', 'Order failed: The store is closed at this time'),
('cu2', 'or2', 'Order failed: The store is closed at this time'),
('cu1', 'or3', 'Order failed:Order address is not in customer addresses list!'),
('cu4', 'or7', 'Order failed: Free deliverymen are not available!'),
('cu3', 'or9', 'Order failed: Enough products are not available'),
('cu3', 'or_10', 'Order failed: The store is closed at this time'),
('cu3', 'or_13', 'Order failed: Free deliverymen are not available!');

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

CREATE TABLE `customer` (
  `username` char(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `customer`
--

INSERT INTO `customer` (`username`) VALUES
('cu1'),
('cu2'),
('cu3'),
('cu4'),
('cu5');

-- --------------------------------------------------------

--
-- Table structure for table `customer_address`
--

CREATE TABLE `customer_address` (
  `username` char(20) DEFAULT NULL,
  `address` varchar(100) DEFAULT NULL,
  `postalCode` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `customer_address`
--

INSERT INTO `customer_address` (`username`, `address`, `postalCode`) VALUES
('cu1', 'Vanak', 1234345678),
('cu2', 'Dolat', 1290673322),
('cu2', 'Ferdosi', 2147483647),
('cu3', 'Sadatabad', 1436789456),
('cu4', 'Tehransar', 1345678099),
('cu4', 'Ekbatan', 1023675488),
('cu5', 'Shahran', 2147483647);

-- --------------------------------------------------------

--
-- Table structure for table `customer_phone`
--

CREATE TABLE `customer_phone` (
  `username` char(20) DEFAULT NULL,
  `phoneNo` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `customer_phone`
--

INSERT INTO `customer_phone` (`username`, `phoneNo`) VALUES
('cu1', 88456700),
('cu1', 44506679),
('cu2', 22906732),
('cu3', 66781527),
('cu4', 33678524),
('cu5', 55909020);

-- --------------------------------------------------------

--
-- Table structure for table `deliveryman`
--

CREATE TABLE `deliveryman` (
  `d_id` char(20) NOT NULL,
  `firstName` varchar(20) DEFAULT NULL,
  `lastName` varchar(30) DEFAULT NULL,
  `phone_no` int(11) DEFAULT NULL,
  `state` set('free','sending') DEFAULT NULL,
  `credit` int(11) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `deliveryman`
--

INSERT INTO `deliveryman` (`d_id`, `firstName`, `lastName`, `phone_no`, `state`, `credit`) VALUES
('d1', 'Ali', 'yunesi', 77337744, 'free', 12000),
('d2', 'Sohrab', 'Ameri', 66558890, 'sending', 50000),
('d3', 'Mahan', 'Nekooyi', 22905656, 'sending', 25000),
('d4', 'Nima', 'Saboori', 33678744, 'sending', 50000),
('d5', 'Ehsan', 'Tabesh', 66789021, 'free', 40000);

--
-- Triggers `deliveryman`
--
DELIMITER $$
CREATE TRIGGER `deliveryman_state_change_LOG` AFTER UPDATE ON `deliveryman` FOR EACH ROW BEGIN
IF OLD.state<>NEW.state THEN
INSERT INTO deliverymanstatechangelog(deliveryman_id,oldState,newState,changeDate) VALUES (NEW.d_id ,OLD.state,NEW.state, NOW());
END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `deliverymanstatechangelog`
--

CREATE TABLE `deliverymanstatechangelog` (
  `deliveryman_id` char(20) NOT NULL,
  `oldState` set('free','sending') DEFAULT NULL,
  `newState` set('free','sending') DEFAULT NULL,
  `changeDate` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `deliverymanstatechangelog`
--

INSERT INTO `deliverymanstatechangelog` (`deliveryman_id`, `oldState`, `newState`, `changeDate`) VALUES
('d1', 'free', 'sending', '2019-01-20 23:47:30'),
('d2', 'free', 'sending', '2019-01-20 23:56:58'),
('d3', 'free', 'sending', '2019-01-21 00:05:55'),
('d2', 'sending', 'free', '2019-01-21 00:19:51'),
('d2', 'free', 'sending', '2019-01-21 00:21:48'),
('d1', 'sending', 'free', '2019-01-21 00:56:09'),
('d4', 'free', 'sending', '2019-01-21 01:12:25'),
('d5', 'free', 'sending', '2019-01-21 01:23:34'),
('d4', 'sending', 'free', '2019-01-21 02:20:56'),
('d4', 'free', 'sending', '2019-01-21 02:27:09'),
('d5', 'sending', 'free', '2019-01-21 02:33:19');

-- --------------------------------------------------------

--
-- Table structure for table `new_customer`
--

CREATE TABLE `new_customer` (
  `username` char(20) DEFAULT NULL,
  `type` int(11) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `new_customer`
--

INSERT INTO `new_customer` (`username`, `type`) VALUES
('cu4', 0),
('cu5', 0);

-- --------------------------------------------------------

--
-- Table structure for table `old_customer`
--

CREATE TABLE `old_customer` (
  `username` char(20) DEFAULT NULL,
  `password1` varchar(42) DEFAULT NULL,
  `type` int(11) NOT NULL DEFAULT '1',
  `email` varchar(40) DEFAULT NULL,
  `firstName` varchar(20) DEFAULT NULL,
  `lastName` varchar(30) DEFAULT NULL,
  `gender` set('female','male') DEFAULT NULL,
  `credit` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `old_customer`
--

INSERT INTO `old_customer` (`username`, `password1`, `type`, `email`, `firstName`, `lastName`, `gender`, `credit`) VALUES
('cu1', '*C436C7CA2FA2BE113A0FB46316B7453946F39063', 1, 'aaa@gmail.com', 'mina', 'naseri', 'female', 60000),
('cu2', '*33ADA231AF5C3F255E9E3AB08829F8375405171B', 1, 'Ar_f@gmail.com', 'Arash', 'Foroozan', 'male', 200000),
('cu3', '*A11EB86EA93B889ED268394AA5DC69D48AF014FA', 1, 'mah_salami@gmail.com', 'Mahtab', 'Salami', 'female', 300000);

--
-- Triggers `old_customer`
--
DELIMITER $$
CREATE TRIGGER `hash_customer_password` BEFORE INSERT ON `old_customer` FOR EACH ROW BEGIN
SET NEW.password1=PASSWORD(NEW.password1);
end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `operator`
--

CREATE TABLE `operator` (
  `op_id` char(20) NOT NULL,
  `firstName` varchar(20) DEFAULT NULL,
  `lastName` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `operator`
--

INSERT INTO `operator` (`op_id`, `firstName`, `lastName`) VALUES
('o1', 'Amir', 'Fathi'),
('o2', 'Arman', 'Fazeli'),
('o3', 'Farhad', 'Kazemi');

-- --------------------------------------------------------

--
-- Table structure for table `order1`
--

CREATE TABLE `order1` (
  `or_id` char(20) NOT NULL,
  `sh_id` char(20) DEFAULT NULL,
  `username` char(20) DEFAULT NULL,
  `deliveryman_id` char(20) DEFAULT NULL,
  `orderState` set('registered','sent','completed','failed') DEFAULT 'registered',
  `payment_type` set('by credit','via bank portal') DEFAULT NULL,
  `orderDate` date DEFAULT NULL,
  `orderAddress` varchar(100) DEFAULT NULL,
  `orderTime` time DEFAULT NULL,
  `flag` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `order1`
--

INSERT INTO `order1` (`or_id`, `sh_id`, `username`, `deliveryman_id`, `orderState`, `payment_type`, `orderDate`, `orderAddress`, `orderTime`, `flag`) VALUES
('or1', 'sh1', 'cu1', NULL, 'failed', 'by credit', '1397-10-24', 'Satarkhan', '04:00:00', 1),
('or2', 'sh1', 'cu2', NULL, 'failed', 'by credit', '1397-10-24', 'Satarkhan', '21:15:27', 1),
('or3', 'sh1', 'cu1', NULL, 'failed', 'by credit', '1397-10-24', 'Satarkhan', '08:30:00', 1),
('or4', 'sh1', 'cu1', 'd1', 'completed', 'by credit', '1397-10-24', 'Vanak', '09:00:00', 1),
('or5', 'sh1', 'cu2', 'd2', 'completed', 'via bank portal', '1397-10-26', 'Ferdosi', '11:40:00', 1),
('or6', 'sh1', 'cu5', 'd3', 'sent', 'via bank portal', '1397-10-27', 'Shahran', '12:04:00', 1),
('or7', 'sh1', 'cu4', NULL, 'failed', 'via bank portal', '1397-10-24', 'Ekbatan', '13:28:00', 1),
('or8', 'sh1', 'cu4', 'd2', 'sent', 'via bank portal', '1397-10-27', 'Ekbatan', '14:11:00', 1),
('or9', 'sh1', 'cu3', NULL, 'failed', 'via bank portal', '1397-10-27', 'Sadatabad', '15:58:00', 1),
('or_10', 'sh2', 'cu3', NULL, 'failed', 'by credit', '1397-10-27', 'Sadatabad', '16:10:00', 1),
('or_11', 'sh2', 'cu3', 'd4', 'completed', 'by credit', '1397-10-28', 'Sadatabad', '06:10:00', 1),
('or_12', 'sh2', 'cu5', 'd5', 'completed', 'via bank portal', '1397-10-28', 'Shahran', '07:20:00', 1),
('or_13', 'sh2', 'cu3', NULL, 'failed', 'by credit', '1397-10-28', 'Sadatabad', '06:10:00', 1),
('or_14', 'sh2', 'cu2', 'd4', 'sent', 'by credit', '1397-10-29', 'Dolat', '08:20:10', 1);

--
-- Triggers `order1`
--
DELIMITER $$
CREATE TRIGGER `orderState_modify` BEFORE UPDATE ON `order1` FOR EACH ROW BEGIN
IF NEW.flag<>OLD.flag THEN


    SET NEW.orderState =   CASE  					WHEN EXISTS (
                                    		SELECT *
                                    		FROM shop
                                    		WHERE shop.sh_id=NEW.sh_id and NEW.orderTime<openTime )
                                      THEN 'failed'
                                      
                                WHEN EXISTS (
                                    		SELECT *
                                    		FROM shop
                                    		WHERE shop.sh_id=NEW.sh_id and NEW.orderTime>closeTime )
                                      THEN 'failed'  
                                      
                                      
                                                                      WHEN EXISTS ( 
                                             SELECT *
                           					 FROM order1,order_product,product 
                           					 WHERE order1.or_id=order_product.order_id and order_product.product_id=product.p_id and order1.sh_id=product.sh_id and order_product.amount > product.amount and order1.or_id=NEW.or_id) 
                                             THEN 'failed'
                                             

                                             
                               WHEN NOT EXISTS (
                                           SELECT *
                                           FROM order1 NATURAL JOIN shop_deliveryman NATURAL JOIN deliveryman
                                           WHERE deliveryman.state='free' and NEW.or_id=order1.or_id)
                                    THEN 'failed'
                                    
    WHEN NEW.orderAddress NOT IN(
        SELECT DISTINCT address
        FROM customer NATURAL JOIN customer_address
        WHERE customer.username = NEW.username)
        
        				THEN 'failed'
                                    
                                    
                ELSE 'sent'                               
	            END;
                
 IF EXISTS (
                                    		SELECT *
                                    		FROM shop
                                    		WHERE shop.sh_id=NEW.sh_id and NEW.orderTime<openTime )
THEN   INSERT INTO conversation(customer_username,order_id,message) VALUES
    (NEW.username,NEW.or_id,"Order failed: The store is closed at this time");
 
             
             
 ELSEIF EXISTS (
                                    		SELECT *
                                    		FROM shop
                                    		WHERE shop.sh_id=NEW.sh_id and NEW.orderTime>closeTime )
                                      THEN   INSERT INTO conversation(customer_username,order_id,message) VALUES
    (NEW.username,NEW.or_id,"Order failed: The store is closed at this time");


 ELSEIF EXISTS ( 
                                             SELECT *
                           					 FROM order1,order_product,product 
                           					 WHERE order1.or_id=order_product.order_id and order_product.product_id=product.p_id and order1.sh_id=product.sh_id and order_product.amount > product.amount and order1.or_id=NEW.or_id) 
     
  THEN   INSERT INTO conversation(customer_username,order_id,message) VALUES
    (NEW.username,NEW.or_id,"Order failed: Enough products are not available");


ELSEIF NOT EXISTS (
                                           SELECT *
                                           FROM order1 NATURAL JOIN shop_deliveryman NATURAL JOIN deliveryman
                                           WHERE deliveryman.state='free' and NEW.or_id=order1.or_id)
THEN INSERT INTO conversation(customer_username,order_id,message) VALUES
    (NEW.username,NEW.or_id,'Order failed: Free deliverymen are not available!');
    

ELSEIF NEW.orderAddress NOT IN(
        SELECT DISTINCT address
        FROM customer NATURAL JOIN customer_address
        WHERE customer.username = NEW.username)
        
THEN INSERT INTO conversation(customer_username,order_id,message) VALUES
    (NEW.username,NEW.or_id,'Order failed:Order address is not in customer addresses list!');
    
ELSE 
set NEW.deliveryman_id= (SELECT  DISTINCT d_id
                          From order1 NATURAL JOIN shop_deliveryman NATURAL JOIN deliveryman
                           WHERE NEW.or_id=order1.or_id and state='free'
                         LIMIT 1
                           );
                           
IF (NEW.username IN (SELECT username
                    FROM old_customer) and NEW.payment_type='by credit') THEN 
                    UPDATE old_customer
                    SET credit=credit- (SELECT SUM(order_product.amount *(price-discount))
                                        FROM order_product,product
                                        WHERE NEW.or_id=order_product.order_id and order_product.product_id = product.p_id)
                     
             WHERE NEW.username=old_customer.username;
 
 ELSE
   UPDATE bank_account
   SET bankCredit=bankCredit - 
   (SELECT SUM(order_product.amount *(price-discount))
    FROM order_product,product
    WHERE NEW.or_id=order_product.order_id and order_product.product_id = product.p_id)             
   WHERE bank_account.username=NEW.username;
 END IF;
 
 UPDATE shop
 SET credit= credit+ 0.95*(SELECT SUM(order_product.amount *(price-discount))
    FROM order_product,product
    WHERE NEW.or_id=order_product.order_id and order_product.product_id = product.p_id)
 WHERE shop.sh_id=NEW.sh_id;
            
END IF;           
  
END IF;

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `orderState_update` AFTER UPDATE ON `order1` FOR EACH ROW BEGIN
IF NEW.orderState<>OLD.orderState THEN
INSERT INTO orderstatechangelog (order_id,oldState,newState,changeDate)VALUES(OLD.or_id,OLD.orderState,NEW.orderState,NOW());
End IF;

IF (NEW.orderState<>OLD.orderState and NEW.orderState='sent')THEN
UPDATE product P
set amount=amount-(SELECT order_product.amount
                   FROM order1,order_product
                   WHERE order1.or_id=NEW.or_id and order1.or_id=order_product.order_id and order_product.product_id=P.p_id)
WHERE P.p_id IN (SELECT product_id
                FROM order_product
                WHERE order_product.order_id=NEW.or_id) ;                  
End IF;

IF (NEW.orderState <> OLD.orderState AND NEW.orderState='completed') THEN
UPDATE deliveryman
SET state='free'
WHERE deliveryman.d_id=NEW.deliveryman_id;
END IF;

IF (NEW.deliveryman_id is not null and OLD.deliveryman_id is null) THEN
	UPDATE deliveryman
    SET state='sending'
    WHERE d_id=NEW.deliveryman_id;
    
  UPDATE deliveryman
  SET credit= credit+ 0.05*
  (SELECT SUM(order_product.amount *(price-discount))
    FROM order_product,product
    WHERE NEW.or_id=order_product.order_id and                order_product.product_id = product.p_id)
  WHERE deliveryman.d_id=NEW.deliveryman_id;

END IF;

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `orderstatechangelog`
--

CREATE TABLE `orderstatechangelog` (
  `order_id` char(20) NOT NULL,
  `oldState` set('registered','sent','completed','failed') DEFAULT NULL,
  `newState` set('registered','sent','completed','failed') DEFAULT NULL,
  `changeDate` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `orderstatechangelog`
--

INSERT INTO `orderstatechangelog` (`order_id`, `oldState`, `newState`, `changeDate`) VALUES
('or1', 'registered', 'failed', '2019-01-20 21:53:01'),
('or2', 'registered', 'failed', '2019-01-20 22:07:02'),
('or3', 'registered', 'failed', '2019-01-20 22:09:54'),
('or4', 'registered', 'sent', '2019-01-20 23:47:30'),
('or5', 'registered', 'sent', '2019-01-20 23:56:58'),
('or6', 'registered', 'sent', '2019-01-21 00:05:55'),
('or7', 'registered', 'failed', '2019-01-21 00:17:19'),
('or5', 'sent', 'completed', '2019-01-21 00:19:51'),
('or8', 'registered', 'sent', '2019-01-21 00:21:48'),
('or4', 'sent', 'completed', '2019-01-21 00:56:09'),
('or9', 'registered', 'failed', '2019-01-21 00:58:49'),
('or_10', 'registered', 'failed', '2019-01-21 01:11:00'),
('or_11', 'registered', 'sent', '2019-01-21 01:12:25'),
('or_12', 'registered', 'sent', '2019-01-21 01:23:34'),
('or_13', 'registered', 'failed', '2019-01-21 02:14:50'),
('or_11', 'sent', 'completed', '2019-01-21 02:20:56'),
('or_14', 'registered', 'sent', '2019-01-21 02:27:09'),
('or_12', 'sent', 'completed', '2019-01-21 02:33:19');

-- --------------------------------------------------------

--
-- Table structure for table `order_product`
--

CREATE TABLE `order_product` (
  `order_id` char(20) DEFAULT NULL,
  `product_id` char(20) DEFAULT NULL,
  `amount` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `order_product`
--

INSERT INTO `order_product` (`order_id`, `product_id`, `amount`) VALUES
('or1', 'p1', 1),
('or2', 'p1', 1),
('or3', 'p1', 1),
('or4', 'p1', 1),
('or4', 'p2', 2),
('or5', 'p1', 5),
('or5', 'p4', 5),
('or6', 'p1', 3),
('or6', 'p3', 2),
('or7', 'p2', 1),
('or7', 'p5', 1),
('or8', 'p2', 1),
('or8', 'p5', 1),
('or9', 'p2', 3),
('or9', 'p1', 5),
('or_10', 'p6', 5),
('or_10', 'p7', 1),
('or_11', 'p6', 5),
('or_11', 'p7', 1),
('or_12', 'p8', 10),
('or_12', 'p9', 1),
('or_13', 'p7', 1),
('or_14', 'p9', 2),
('or_14', 'p7', 3);

-- --------------------------------------------------------

--
-- Table structure for table `product`
--

CREATE TABLE `product` (
  `p_id` char(20) NOT NULL,
  `p_title` varchar(20) DEFAULT NULL,
  `sh_id` char(20) DEFAULT NULL,
  `price` int(11) DEFAULT NULL,
  `discount` int(11) DEFAULT NULL,
  `amount` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `product`
--

INSERT INTO `product` (`p_id`, `p_title`, `sh_id`, `price`, `discount`, `amount`) VALUES
('p1', 'kif1', 'sh1', 110000, 10000, 1),
('p2', 'kif2', 'sh1', 80000, 10000, 17),
('p3', 'kif3', 'sh1', 120000, 20000, 8),
('p4', 'kif4', 'sh1', 70000, 0, 20),
('p5', 'kif5', 'sh1', 100000, 20000, 14),
('p6', 'kafsh1', 'sh2', 80000, 0, 7),
('p7', 'kafsh2', 'sh2', 120000, 20000, 13),
('p8', 'kafsh3', 'sh2', 70000, 0, 10),
('p9', 'kafsh4', 'sh2', 130000, 30000, 21);

-- --------------------------------------------------------

--
-- Table structure for table `shop`
--

CREATE TABLE `shop` (
  `sh_id` char(20) NOT NULL,
  `title` varchar(20) DEFAULT NULL,
  `city` varchar(20) DEFAULT NULL,
  `address` varchar(100) DEFAULT NULL,
  `phone_no` int(11) DEFAULT NULL,
  `manager_name` varchar(30) DEFAULT NULL,
  `openTime` time DEFAULT NULL,
  `closeTime` time DEFAULT NULL,
  `credit` int(11) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `shop`
--

INSERT INTO `shop` (`sh_id`, `title`, `city`, `address`, `phone_no`, `manager_name`, `openTime`, `closeTime`, `credit`) VALUES
('sh1', 'vendor1', 'Tehran', 'Pasdaran', 77337744, 'Asghari', '07:00:00', '19:00:00', 1653000),
('sh2', 'vendor2', 'Tehran', 'Narmak', 33557744, 'Sameti', '06:00:00', '15:00:00', 1710000);

-- --------------------------------------------------------

--
-- Table structure for table `shop_deliveryman`
--

CREATE TABLE `shop_deliveryman` (
  `sh_id` char(20) DEFAULT NULL,
  `d_id` char(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `shop_deliveryman`
--

INSERT INTO `shop_deliveryman` (`sh_id`, `d_id`) VALUES
('sh1', 'd1'),
('sh1', 'd2'),
('sh1', 'd3'),
('sh2', 'd4'),
('sh2', 'd5');

-- --------------------------------------------------------

--
-- Table structure for table `shop_operator`
--

CREATE TABLE `shop_operator` (
  `sh_id` char(20) DEFAULT NULL,
  `op_id` char(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `shop_operator`
--

INSERT INTO `shop_operator` (`sh_id`, `op_id`) VALUES
('sh1', 'o1'),
('sh2', 'o2'),
('sh2', 'o3');

-- --------------------------------------------------------

--
-- Table structure for table `shop_supporter`
--

CREATE TABLE `shop_supporter` (
  `sh_id` char(20) DEFAULT NULL,
  `sup_id` char(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `shop_supporter`
--

INSERT INTO `shop_supporter` (`sh_id`, `sup_id`) VALUES
('sh1', 'sup1'),
('sh2', 'sup2'),
('sh1', 'sup3');

-- --------------------------------------------------------

--
-- Table structure for table `supporter`
--

CREATE TABLE `supporter` (
  `sup_id` char(20) NOT NULL,
  `firstName` varchar(20) DEFAULT NULL,
  `lastName` varchar(30) DEFAULT NULL,
  `phone_no` int(11) DEFAULT NULL,
  `address` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `supporter`
--

INSERT INTO `supporter` (`sup_id`, `firstName`, `lastName`, `phone_no`, `address`) VALUES
('sup1', 'Amir', 'Sobhani', 44787860, 'Marzdaran'),
('sup2', 'Saman', 'Akbari', 44990077, 'Vanak'),
('sup3', 'Babak', 'Davoodi', 22143480, 'Gholhak');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `bank_account`
--
ALTER TABLE `bank_account`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `username` (`username`);

--
-- Indexes for table `charging_credit`
--
ALTER TABLE `charging_credit`
  ADD KEY `username` (`username`);

--
-- Indexes for table `conversation`
--
ALTER TABLE `conversation`
  ADD KEY `order_id` (`order_id`),
  ADD KEY `customer_username` (`customer_username`);

--
-- Indexes for table `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`username`);

--
-- Indexes for table `customer_address`
--
ALTER TABLE `customer_address`
  ADD KEY `username` (`username`);

--
-- Indexes for table `customer_phone`
--
ALTER TABLE `customer_phone`
  ADD KEY `username` (`username`);

--
-- Indexes for table `deliveryman`
--
ALTER TABLE `deliveryman`
  ADD PRIMARY KEY (`d_id`);

--
-- Indexes for table `new_customer`
--
ALTER TABLE `new_customer`
  ADD KEY `username` (`username`);

--
-- Indexes for table `old_customer`
--
ALTER TABLE `old_customer`
  ADD KEY `username` (`username`);

--
-- Indexes for table `operator`
--
ALTER TABLE `operator`
  ADD PRIMARY KEY (`op_id`);

--
-- Indexes for table `order1`
--
ALTER TABLE `order1`
  ADD PRIMARY KEY (`or_id`),
  ADD KEY `sh_id` (`sh_id`),
  ADD KEY `username` (`username`);

--
-- Indexes for table `order_product`
--
ALTER TABLE `order_product`
  ADD KEY `order_id` (`order_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`p_id`),
  ADD KEY `sh_id` (`sh_id`);

--
-- Indexes for table `shop`
--
ALTER TABLE `shop`
  ADD PRIMARY KEY (`sh_id`);

--
-- Indexes for table `shop_deliveryman`
--
ALTER TABLE `shop_deliveryman`
  ADD KEY `sh_id` (`sh_id`),
  ADD KEY `d_id` (`d_id`);

--
-- Indexes for table `shop_operator`
--
ALTER TABLE `shop_operator`
  ADD KEY `sh_id` (`sh_id`),
  ADD KEY `op_id` (`op_id`);

--
-- Indexes for table `shop_supporter`
--
ALTER TABLE `shop_supporter`
  ADD KEY `sh_id` (`sh_id`),
  ADD KEY `sup_id` (`sup_id`);

--
-- Indexes for table `supporter`
--
ALTER TABLE `supporter`
  ADD PRIMARY KEY (`sup_id`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `bank_account`
--
ALTER TABLE `bank_account`
  ADD CONSTRAINT `bank_account_ibfk_1` FOREIGN KEY (`username`) REFERENCES `customer` (`username`);

--
-- Constraints for table `charging_credit`
--
ALTER TABLE `charging_credit`
  ADD CONSTRAINT `charging_credit_ibfk_1` FOREIGN KEY (`username`) REFERENCES `old_customer` (`username`);

--
-- Constraints for table `conversation`
--
ALTER TABLE `conversation`
  ADD CONSTRAINT `conversation_ibfk_1` FOREIGN KEY (`customer_username`) REFERENCES `customer` (`username`);

--
-- Constraints for table `customer_address`
--
ALTER TABLE `customer_address`
  ADD CONSTRAINT `customer_address_ibfk_1` FOREIGN KEY (`username`) REFERENCES `customer` (`username`);

--
-- Constraints for table `customer_phone`
--
ALTER TABLE `customer_phone`
  ADD CONSTRAINT `customer_phone_ibfk_1` FOREIGN KEY (`username`) REFERENCES `customer` (`username`);

--
-- Constraints for table `new_customer`
--
ALTER TABLE `new_customer`
  ADD CONSTRAINT `new_customer_ibfk_1` FOREIGN KEY (`username`) REFERENCES `customer` (`username`);

--
-- Constraints for table `old_customer`
--
ALTER TABLE `old_customer`
  ADD CONSTRAINT `old_customer_ibfk_1` FOREIGN KEY (`username`) REFERENCES `customer` (`username`);

--
-- Constraints for table `order1`
--
ALTER TABLE `order1`
  ADD CONSTRAINT `order1_ibfk_1` FOREIGN KEY (`sh_id`) REFERENCES `shop` (`sh_id`),
  ADD CONSTRAINT `order1_ibfk_2` FOREIGN KEY (`username`) REFERENCES `customer` (`username`);

--
-- Constraints for table `order_product`
--
ALTER TABLE `order_product`
  ADD CONSTRAINT `order_product_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `order1` (`or_id`),
  ADD CONSTRAINT `order_product_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `product` (`p_id`);

--
-- Constraints for table `product`
--
ALTER TABLE `product`
  ADD CONSTRAINT `product_ibfk_1` FOREIGN KEY (`sh_id`) REFERENCES `shop` (`sh_id`);

--
-- Constraints for table `shop_deliveryman`
--
ALTER TABLE `shop_deliveryman`
  ADD CONSTRAINT `shop_deliveryman_ibfk_1` FOREIGN KEY (`sh_id`) REFERENCES `shop` (`sh_id`),
  ADD CONSTRAINT `shop_deliveryman_ibfk_2` FOREIGN KEY (`d_id`) REFERENCES `deliveryman` (`d_id`);

--
-- Constraints for table `shop_operator`
--
ALTER TABLE `shop_operator`
  ADD CONSTRAINT `shop_operator_ibfk_1` FOREIGN KEY (`sh_id`) REFERENCES `shop` (`sh_id`),
  ADD CONSTRAINT `shop_operator_ibfk_2` FOREIGN KEY (`op_id`) REFERENCES `operator` (`op_id`);

--
-- Constraints for table `shop_supporter`
--
ALTER TABLE `shop_supporter`
  ADD CONSTRAINT `shop_supporter_ibfk_1` FOREIGN KEY (`sh_id`) REFERENCES `shop` (`sh_id`),
  ADD CONSTRAINT `shop_supporter_ibfk_2` FOREIGN KEY (`sup_id`) REFERENCES `supporter` (`sup_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
