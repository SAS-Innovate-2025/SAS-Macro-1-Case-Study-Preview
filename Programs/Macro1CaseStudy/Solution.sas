/*************************************/
/* SAS Macro 1 Case Study Preview    */
/* SAS Innovate 2025                 */
/* Carleigh Jo Crabtree              */
/* Starter Program                   */
/*************************************/

/* 1. & 18. */ 
%macro SupplierReport(ot) / mInOperator;

/* 19. */
%IF &ot= %THEN %DO;
	%PUT ERROR: You did not specify an Order_Type value (required).;
	%PUT ERROR- Valid Order_Type values include 1 (Retail Sales), 2 (Catalog Sales), or 3 (Internet Sales).;
	%PUT ERROR- Program will stop executing.;
	%RETURN;
%END;
	
/* 20. */
%ELSE %IF NOT (&ot in 1 2 3) %THEN %DO;
	%PUT ERROR: You must enter a valid value for the parameter.;
	%PUT ERROR- Valid Order_Type values include 1 (Retail Sales), 2 (Catalog Sales), or 3 (Internet Sales).;
	%PUT ERROR- Program will stop executing.;
	%RETURN;	
%END;

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
/* 3. */	
	where order_type= &ot;
quit;	

/* Part B */
/* Summarizes profit and ranks each supplier for retail sales */
/* Top supplier is Eclipse Inc. ID #1303 */

proc sql;
select distinct Supplier_ID format=12., 
                sum(profit) as Profit,
				Supplier_Name
/* 4. */
	   into :topSupp1-:topSupp5,
	   		:Profit1-:Profit5,
	   		:Name1-:Name5
	   
    from OrderDetail
	group by Supplier_ID, Supplier_Name
	order by Profit desc;
quit;
	
/* 5. */
%PUT _USER_;

/* Part C */
/* Generates PDF of retail sales for the top supplier Eclipse Inc. ID #1303 */
/* PDF includes: */
/*	 bar chart of product categories from top supplier Eclipse Inc. */
/* 	 summary report of orders and sales from selected supplier Eclipse Inc. ID #1303 */
	  
options nodate;
ods graphics on / imagefmt=png; 

/* 7. */ 
%local i;

/* 6. */ 
%do i=1 %to 5;

/* 13. */
/* ods pdf file="&path/case_study/&i..pdf" style=meadow startpage=no nogtitle; */

/* 25. */
ods pdf file="&path/case_study/%ReplaceSpace(&i &&Name&i).pdf" style=meadow startpage=no nogtitle;

/* 14. */
title "Orders for #&i &&name&i";

/* 15. */
%IF &ot=1 %THEN %DO;
	title2 "Retail Sales Only";
%END;

%ELSE %IF &ot=2 %THEN %DO;
	title2 "Catalog Sales Only";
%END;

%ELSE %IF &ot=3 %THEN %DO;
	title2 "Internet Sales Only";
%END;

/*Create a summary bar chart by Product_Category*/

proc sgplot data=OrderDetail noautolegend ;
	hbar Product_Category / response=profit stat=sum group=Product_Category categoryorder=respdesc;
/* 11. */
	where Supplier_ID=&&topsupp&i;
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
/* 12. */
	where Supplier_ID=&&topsupp&i
	group by Product_Group
	order by calculated numorders desc;
quit;

ods pdf close;

/* 9. */ 
%PUT &=i;

/* 8. */ 
%end;

/* 2. */
%mend;

/* 10., 17., 22., 26. */
%SupplierReport(1)

