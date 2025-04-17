/*************************************/
/* SAS Macro 1 Case Study Preview    */
/* SAS Innovate 2025                 */
/* Carleigh Jo Crabtree              */
/* Instructions                      */
/*************************************/

/*

***************************************************************************************   

    Run Part A to create OrderDetail, before making modifications.

    Goal: Create %SupplierReport macro and allow user to 
	      input order type.

 1. At the top of the program, start a macro definition 
    named SupplierReport with ot as a positional parameter.
   
%macro SupplierReport(ot);

***************************************************************************************   

 2. At the very end of the program after ods pdf close; 
    end the macro definition with a %MEND statement. 

%mend;

***************************************************************************************   

    Goal: Filter data for selected order type:
	      ot=1 (Retail Sales)
	      ot=2 (Catalog Sales)
	      ot=3 (Internet Sales)
   		   
 3. In Part A, modify the WHERE clause to include 
    rows where Order_Type is equal to the ot macro variable.  
    
where order_type= &ot;

***************************************************************************************   

    Goal: Create macro variables to hold values of the top five
	      supplier ID's, profit amounts and supplier names.   
   
 4. In Part B, add an INTO clause to create the following series 
    of macro variables for the top five suppliers:
		TopSupp1-TopSupp5 to store the Supplier_ID values.
		Profit1-Profit5 to store the sum of Profit values.
		Name1-Name5 to store the Supplier_Name values.
		
into :topSupp1-:topSupp5,
	 :Profit1-:Profit5,
	 :Name1-:Name5

***************************************************************************************   

 5. Add %PUT _USER_; to validate macro variables and values.
 
%PUT _USER_;

***************************************************************************************   

    Goal: Generate five PDF's, one for each of the top five suppliers.

 6. After the ODS GRAPHICS statement, add a %DO macro statement 
    with an index variable i that starts at 1 and ends at 5. 
    
%do i=1 %to 5;

***************************************************************************************   

 7. Before the %DO statement, add a %LOCAL statement to ensure 
    that i is written to and read from the local symbol table.
    
%local i;

***************************************************************************************   
   
 8. At the end of the program, between ods pdf close; and 
    the %MEND statement, add a %END statement. 
    
%end;

***************************************************************************************   
   
 9. Add %PUT &=i; inside the loop (between %DO and %END). 
    Verify the values for i are 1 through 5. 
    
%PUT &=i;    

***************************************************************************************   
    
10. Compile and run the SupplierReport macro. 
    	
%SupplierReport(1)

***************************************************************************************   

    Goal: Filter data depending on the relevant supplier ID.
	      Ex. TopSupp1, TopSupp2...

11. In the PROC SGPLOT in Part C, modify the WHERE statement to 
    use an indirect macro variable reference to substitute 
    the Supplier_ID value. 
    	Indirect reference resolution:
    		Scan 1: &&topsupp&i
    		Scan 2:  &topsupp1
    		Resolution: 1303
    
where Supplier_ID=&&topsupp&i;

***************************************************************************************   

12. In the PROC SQL in Part C, modify the WHERE statement to 
    use an indirect macro variable reference to substitute 
    the Supplier_ID value. 
    
where Supplier_ID=&&topsupp&i

***************************************************************************************   

    Goal: Update the PDF name depending on the supplier rank.

13. In the ODS PDF statement in Part C, replace the file name, 
    1.pdf (excluding .pdf) with a dynamic file name:
		Replace the number 1 with the current value of i to refer
			to the rank of the company, first through fifth.

ods pdf file="&path/case_study/&i..pdf" 
	style=meadow startpage=no nogtitle;

***************************************************************************************   

    Goal: Update report titles depending on the rank, supplier name
	      and order type.

14. Modify the first title inside the PDF:
		Use the i macro variable to substitute the rank 
			number of the supplier.
		Use an indirect macro variable reference to substitute 
			the macro variable value for Name1, Name2, and so on.
	    	Indirect reference resolution:
	    		Scan 1: &&name&i
	    		Scan 2:  &name1
	    		Resolution: Eclipse Inc
	    		
title "Orders for #&i &&name&i";

***************************************************************************************   

15. To create the second title, use %IF %ELSE %THEN %DO and %END 
    statements to provide a unique TITLE2 statement depending on 
    the value of the ot parameter.
    	1= Retail Sales Only
    	2= Catalog Sales Only
    	3= Internet Sales Only

%IF &ot=1 %THEN %DO;
	title2 "Retail Sales Only";
%END;

%ELSE %IF &ot=2 %THEN %DO;
	title2 "Catalog Sales Only";
%END;

%ELSE %IF &ot=3 %THEN %DO;
	title2 "Internet Sales Only";
%END;

***************************************************************************************   

16. Compile the macro.

***************************************************************************************   

17. Run the SupplierReport macro with a value of 1, 2 or 3.

%SupplierReport(1)

***************************************************************************************   

    Bonus: Parameter Error Handling and Autocall Macros

    Goal: Create custom errors when no parameter is submitted or
	      an invalid value for ot is submitted.

18. Add the /mInOperator option in the %MACRO statement to
	enable the IN operator in a macro.
	
%macro SupplierReport(ot) / mInOperator;

***************************************************************************************   
	
19. Use %IF %THEN %DO groups and %END statements to test 
	whether the parameter is equal to a null value. If it 
	is, use %PUT statements to write error messages 
	in the log. Add %RETURN to stop the program.
		
%IF &ot= %THEN %DO;
	%PUT ERROR: You did not specify an Order_Type value (required).;
	%PUT ERROR- Valid Order_Type values include 1 (Retail Sales), 
				2 (Catalog Sales), or 3 (Internet Sales).;
	%PUT ERROR- Program will stop executing.;
	%RETURN;
%END;

***************************************************************************************   

20. Use %ELSE %IF %THEN %DO and %END statements to test 
	whether the parameter is not in the list of 1, 2, or 3. 
	If it is not, use %PUT statements to write an error 
	message in the log. Add %RETURN to stop the program:

%ELSE %IF NOT (&ot in 1 2 3) %THEN %DO;
	%PUT ERROR: You must enter a valid value for the parameter.;
	%PUT ERROR- Valid Order_Type values include 1 (Retail Sales), 
				2 (Catalog Sales), or 3 (Internet Sales).;
	%PUT ERROR- Program will stop executing.;
	%RETURN;
%END;

***************************************************************************************   

21. Compile the macro.

***************************************************************************************   

22. Run the SupplierReport macro with a null value and a
	value that is not 1, 2 or 3.

%SupplierReport()

***************************************************************************************   

    Goal: Update the PDF depending on the supplier name. 
	      Ensure spaces in supplier names are underscores in the PDF name.	
	  
23. Explore and run the AutoExec program.

***************************************************************************************   

24. Explore the ReplaceSpace macro stored in the autocall folder.
    Run the %PUT statement to see how ReplaceSpace works.
 
***************************************************************************************   

25. In the ODS PDF statement in Part C, add on to the file name,
	&i..pdf to include the current supplier name. Replace spaces
	with underscores. 
		The filenames should appear as: 
			1_Eclipse_Inc.pdf
		Delete the second period after &i and put a single 
			space character after the &i macro variable.
		Add an indirect macro variable reference that substitutes
			the value of the Name1, Name2 (and so on) macro variable.
		Call the ReplaceSpace macro to replace spaces in the 
			file name with underscores. Enclose the file name 
			in parentheses, excluding .pdf.
		
ods pdf file="&path/case_study/%ReplaceSpace(&i &&Name&i).pdf" 
	style=meadow startpage=no nogtitle;

***************************************************************************************   

26. Compile and run the SupplierReport macro with a value of 1, 2 or 3.

%SupplierReport(2)

***************************************************************************************   

*/








