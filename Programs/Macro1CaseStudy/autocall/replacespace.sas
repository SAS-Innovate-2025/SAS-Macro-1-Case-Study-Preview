/****************************************************************************/
/* %sysfunc(): enables the macro processor to execute SAS functions         */
/* tranwrd(): replaces all occurrences of a substring in a character string */
/* tranwrd(string, substring you want to replace, replacement)              */
/* Macro function arguments are not quoted.                                 */
/* How can you tell SAS	a space is the substring to replace? Use %str()     */
/* %str(): masks all special characters except % and & so they are          */
/*		   treated as regular text by the macro processor                   */
/*                                                                          */
/* %sysfunc(execute the SAS function tranwrd)                               */
/* tranwrd(in specified text,                                               */
/*	%str(replace spaces which will now be treated as regular text),         */
/*		replace spaces with an underscore))                                 */
/****************************************************************************/

%macro replacespace(text);
	%sysfunc(tranwrd(&text,%str( ),_))
%mend replacespace;
