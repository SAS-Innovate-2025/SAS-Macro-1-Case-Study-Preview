/*************************************/
/* SAS Macro 1 Case Study Preview    */
/* SAS Innovate 2025                 */
/* Carleigh Jo Crabtree              */
/* Starter Program                   */
/*************************************/

/* Part A */
/* Joins 2 tables: orders and products */
/* Filters for one order_type: 1 (retail sales) */
/* Calculates profit per order */

proc sql;
create table OrderDetail as 
select Order_ID, o.Product_ID, Order_Type, Product_Category, 
       Product_Group, Product_Line, Product_Name, 
       ((total_retail_price-costprice_per_unit)/quantity) as Profit,
       Supplier_ID, Supplier_Name
    from mc1.orders as o left join mc1.products as p
	on o.Product_ID=p.Product_ID
	where order_type=1;
quit;	

/* Part B */
/* Summarizes profit and ranks each supplier for retail sales */
/* Top supplier is Eclipse Inc. ID #1303 */

proc sql;
select distinct Supplier_ID format=12., 
                sum(profit) as Profit,
				Supplier_Name
    from OrderDetail
	group by Supplier_ID, Supplier_Name
	order by Profit desc;
quit;

/* Part C */
/* Generates PDF of retail sales for the top supplier Eclipse Inc. ID #1303 */
/* PDF includes: */
/*	 bar chart of product categories from top supplier Eclipse Inc. */
/* 	 summary report of orders and sales from selected supplier Eclipse Inc. ID #1303 */
	  
options nodate;
ods graphics on / imagefmt=png; 
ods pdf file="&path/case_study/1.pdf" style=meadow startpage=no nogtitle;

title "Orders for #1 Eclipse Inc";	
title2 "Retail Sales Only";

/*Create a summary bar chart by Product_Category*/

proc sgplot data=OrderDetail noautolegend ;
	hbar Product_Category / response=profit stat=sum group=Product_Category categoryorder=respdesc;
	where Supplier_ID=1303;
	format profit dollar8.;
run;
title;

/*Create a summary report of orders and sales for the selected supplier*/

proc sql;
	select Product_Group, 
           count(order_id) as NumOrders "Number of Orders", 
           sum(profit) as TotalProfit "Total Profit" format=dollar8., 
           avg(profit) as AvgProfit "Average Profit per Order" format=dollar6.
	from OrderDetail
	where Supplier_ID=1303
	group by Product_Group
	order by calculated numorders desc;
quit;

ods pdf close;


