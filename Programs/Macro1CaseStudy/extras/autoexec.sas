%let path=/home/student/casuser/Macro1CaseStudy;
 
libname mc1 "/home/student/casuser/Macro1CaseStudy/data";

/****************************************************************************************************************************/
/* Autocall library includes .sas programs that each have a single macro definition.                                        */
/* Autocall facility calls macros in autocall library without having to open and submit the macro definiton.                */
/* sasautos= provides the location of the autocall library, SASAUTOS is the fileref for autocall macros supplied by SAS.    */
/* mAutoSource ensures the autocall feature is available.                                                                   */
/****************************************************************************************************************************/

options mautosource sasautos=("/home/student/casuser/Macro1CaseStudy/autocall", SASAUTOS);
