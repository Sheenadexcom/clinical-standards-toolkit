**********************************************************************************;
* Copyright (c) 2022, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.   *;
* SPDX-License-Identifier: Apache-2.0                                            *;
*                                                                                *;
* validate_data.sas                                                              *;
*                                                                                *;
* Sample driver program to perform a primary Toolkit action, in this case,       *;
* validation, to assess compliance of some source data and metadata with a       *;
* registered standard.  A call to a standard-specific validation macro is        *;
* required later in this code.                                                   *;
*                                                                                *;
* Assumptions:                                                                   *;
*   The SASReferences file must exist, and must be identified in the call to     *;
*    cstutil_processsetup if it is not work.sasreferences.                       *;
*                                                                                *;
* CSTversion  1.6                                                                *;
**********************************************************************************;

%let _cstStandard=CDISC-SDTM;
%let _cstStandardVersion=3.2;        * <------- 3.1.1, 3.1.2, 3.1.3, or 3.2           *;
%let _cstCTPath=;
%let _cstCTMemname=;
%let _cstCTDescription=;

%cst_setStandardProperties(_cstStandard=CST-FRAMEWORK,_cstSubType=initialize);

* Set Controlled Terminology version for this process  *;
%cst_getstandardsubtypes(_cstStandard=CDISC-TERMINOLOGY,_cstOutputDS=work._cstStdSubTypes);
data _null_;
  set work._cstStdSubTypes (where=(standardversion="&_cstStandard" and isstandarddefault='Y'));
  * User can override CT version of interest by specifying a different where clause:            *;
  * Example: (where=(standardversion="&_cstStandard" and standardsubtypeversion='201104'))   *;
  call symputx('_cstCTPath',path);
  call symputx('_cstCTMemname',memname);
  call symputx('_cstCTDescription',description);
run;

proc datasets lib=work nolist;
  delete _cstStdSubTypes;
quit;

*****************************************************************************************************;
* The following data step sets (at a minimum) the studyrootpath and studyoutputpath.  These are     *;
* used to make the driver programs portable across platforms and allow the code to be run with      *;
* minimal modification. These nacro variables by default point to locations within the              *;
* cstSampleLibrary, set during install but modifiable thereafter.  The cstSampleLibrary is assumed  *;
* to allow write operations by this driver module.                                                  *;
*****************************************************************************************************;

%cstutil_setcstsroot;
data _null_;
  call symput('studyRootPath',cats("&_cstSRoot","/cdisc-sdtm-&_cstStandardVersion-&_cstVersion/sascstdemodata"));
  call symput('studyOutputPath',cats("&_cstSRoot","/cdisc-sdtm-&_cstStandardVersion-&_cstVersion/sascstdemodata"));
run;
%let workPath=%sysfunc(pathname(work));

%let _cstSetupSrc=SASREFERENCES;

*****************************************************************************************;
* One strategy to defining the required library and file metadata for a CST process     *;
*  is to optionally build SASReferences in the WORK library.  An example of how to do   *;
*  this follows.                                                                        *;
*                                                                                       *;
* The call to cstutil_processsetup below tells CST how SASReferences will be provided   *;
*  and referenced.  If SASReferences is built in work, the call to cstutil_processsetup *;
*  may, assuming all defaults, be as simple as  %cstutil_processsetup()                 *;
*****************************************************************************************;

*************************************************************************************************;
* Build the SASReferences data set                                                              *;
* column order:  standard, standardversion, type, subtype, sasref, reftype, iotype, filetype,   *;
*                allowoverwrite, relpathprefix, path, order, memname, comment                   *;
* note that &_cstGRoot points to the Global Library root directory                              *;
* path and memname are not required for Global Library references - defaults will be used       *;
*************************************************************************************************;
%cst_createdsfromtemplate(_cstStandard=CST-FRAMEWORK, _cstType=control,_cstSubType=reference, _cstOutputDS=work.sasreferences);
proc sql;
  insert into work.sasreferences
  values ("CST-FRAMEWORK"     "1.2"                   "messages"          ""                  "messages" "libref"  "input"  "dataset"  "N"  "" ""                                               1 ""                            "")
  values ("CST-FRAMEWORK"     "1.2"                   "template"          ""                  "csttmplt" "libref"  "input"  "folder"   "N"  "" ""                                               2 ""                            "")
  values ("&_cstStandard"     "&_cstStandardVersion"  "autocall"          ""                  "sdtmauto" "fileref" "input"  "folder"   "N"  "" ""                                               1 ""                            "")
  values ("&_cstStandard"     "&_cstStandardVersion"  "control"           "reference"         "cntl_s"   "libref"  "both"   "dataset"  "Y"  "" "&workpath"                                      . "sasreferences.sas7bdat"      "")
  values ("&_cstStandard"     "&_cstStandardVersion"  "control"           "validation"        "cntl_v"   "libref"  "input"  "dataset"  "N"  "" "&studyRootPath/control"                         . "validation_control.sas7bdat" "")
  values ("&_cstStandard"     "&_cstStandardVersion"  "fmtsearch"         ""                  "srcfmt"   "libref"  "input"  "catalog"  "N"  "" "&studyRootPath/terminology/formats"             1 "formats.sas7bcat"            "")
  values ("&_cstStandard"     "&_cstStandardVersion"  "messages"          ""                  "sdtmmsg"  "libref"  "input"  "dataset"  "N"  "" ""                                               2 ""                            "")
  values ("&_cstStandard"     "&_cstStandardVersion"  "lookup"            ""                  "lookup"   "libref"  "input"  "dataset"  "N"  "" ""                                               . ""                            "")
  values ("&_cstStandard"     "&_cstStandardVersion"  "template"          ""                  "sdtmtmpl" "libref"  "input"  "folder"   "N"  "" ""                                               1 ""                            "")
  values ("&_cstStandard"     "&_cstStandardVersion"  "properties"        "initialize"        "inprop"   "fileref" "input"  "file"     "N"  "" ""                                               1 ""                            "")
  values ("&_cstStandard"     "&_cstStandardVersion"  "properties"        "validation"        "valprop"  "fileref" "input"  "file"     "N"  "" "&studyRootPath/programs"                        2 "validation.properties"       "")
  values ("&_cstStandard"     "&_cstStandardVersion"  "referencecontrol"  "validation"        "refcntl"  "libref"  "input"  "dataset"  "N"  "" ""                                               . ""                            "")
  values ("&_cstStandard"     "&_cstStandardVersion"  "referencecontrol"  "standardref"       "refcntl"  "libref"  "input"  "dataset"  "N"  "" ""                                               . ""                            "")
  values ("&_cstStandard"     "&_cstStandardVersion"  "referencecterm"    ""                  "ctref"    "libref"  "input"  "dataset"  "N"  "" "&studyRootPath/terminology/coding-dictionaries" . "meddra.sas7bdat"             "")
  values ("&_cstStandard"     "&_cstStandardVersion"  "referencemetadata" "column"            "refmeta"  "libref"  "input"  "dataset"  "N"  "" ""                                               . ""                            "")
  values ("&_cstStandard"     "&_cstStandardVersion"  "referencemetadata" "table"             "refmeta"  "libref"  "input"  "dataset"  "N"  "" ""                                               . ""                            "")
  values ("&_cstStandard"     "&_cstStandardVersion"  "results"           "validationmetrics" "results"  "libref"  "output" "dataset"  "Y"  "" "&studyOutputPath/results"                       . "validation_metrics.sas7bdat" "")
  values ("&_cstStandard"     "&_cstStandardVersion"  "results"           "validationresults" "results"  "libref"  "output" "dataset"  "Y"  "" "&studyOutputPath/results"                       . "validation_results.sas7bdat" "")
  values ("&_cstStandard"     "&_cstStandardVersion"  "sourcedata"        ""                  "srcdata"  "libref"  "input"  "folder"   "N"  "" "&studyRootPath/data"                            . ""                            "")
  values ("&_cstStandard"     "&_cstStandardVersion"  "sourcemetadata"    "column"            "srcmeta"  "libref"  "input"  "dataset"  "N"  "" "&studyRootPath/metadata"                        . "source_columns.sas7bdat"     "")
  values ("&_cstStandard"     "&_cstStandardVersion"  "sourcemetadata"    "table"             "srcmeta"  "libref"  "input"  "dataset"  "N"  "" "&studyRootPath/metadata"                        . "source_tables.sas7bdat"      "")
  values ("CDISC-TERMINOLOGY" "NCI_THESAURUS"         "fmtsearch"         ""                  "cstfmt"   "libref"  "input"  "catalog"  "N"  "" "&_cstCTPath"                                    2  "&_cstCTMemname"             "")
  ;
quit;

************************************************************;
* Debugging aid:  set _cstDebug=1                          *;
* Note value may be reset in call to cstutil_processsetup  *;
*  based on property settings.  It can be reset at any     *;
*  point in the process.                                   *;
************************************************************;
%let _cstDebug=0;
data _null_;
  _cstDebug = input(symget('_cstDebug'),8.);
  if _cstDebug then
    call execute("options &_cstDebugOptions;");
  else
    call execute(("%sysfunc(tranwrd(options %cmpres(&_cstDebugOptions), %str( ), %str( no)));"));
run;

*****************************************************************************************;
* Clinical Standards Toolkit utilizes autocall macro libraries to contain and           *;
*  reference standard-specific code libraries.  Once the autocall path is set and one   *;
*  or more macros have been used within any given autocall library, deallocation or     *;
*  reallocation of the autocall fileref cannot occur unless the autocall path is first  *;
*  reset to exclude the specific fileref.                                               *;
*                                                                                       *;
* This becomes a problem only with repeated calls to %cstutil_processsetup() or         *;
*  %cstutil_allocatesasreferences within the same sas session.  Doing so, without       *;
*  submitting code similar to the code below may produce SAS errors such as:            *;
*     ERROR - At least one file associated with fileref SDTMAUTO is still in use.       *;
*     ERROR - Error in the FILENAME statement.                                          *;
*                                                                                       *;
* If you call %cstutil_processsetup() or %cstutil_allocatesasreferences more than once  *;
*  within the same sas session, typically using %let _cstReallocateSASRefs=1 to tell    *;
*  CST to attempt reallocation, use of the following code is recommended between each   *;
*  code submission.                                                                     *;
*                                                                                       *;
* Use of the following code is NOT needed to run this driver module initially.          *;
*****************************************************************************************;

%*let _cstReallocateSASRefs=1;
%*include "&_cstGRoot/standards/cst-framework-&_cstVersion/programs/resetautocallpath.sas";

*****************************************************************************************;
* The following macro (cstutil_processsetup) utilizes the following parameters:         *;
*                                                                                       *;
* _cstSASReferencesSource - Setup should be based upon what initial source?             *;
*   Values: SASREFERENCES (default) or RESULTS data set. If RESULTS:                    *;
*     (1) no other parameters are required and setup responsibility is passed to the    *;
*                 cstutil_reportsetup macro                                             *;
*     (2) the results data set name must be passed to cstutil_reportsetup as            *;
*                 libref.memname                                                        *;
*                                                                                       *;
* _cstSASReferencesLocation - The path (folder location) of the sasreferences data set  *;
*                              (default is the path to the WORK library)                *;
*                                                                                       *;
* _cstSASReferencesName - The name of the sasreferences data set                        *;
*                              (default is sasreferences)                               *;
*****************************************************************************************;

%cstutil_processsetup();

**********************************************************************************;
* Run the standard-specific validation macro.                                    *;
**********************************************************************************;

%sdtm_validate;

* Delete sasreferences if created above and not needed for additional processing  *;
proc datasets lib=work nolist;
  delete sasreferences / memtype=data;
quit;

**********************************************************************************;
* Clean-up the CST process files, macro variables and macros.                    *;
**********************************************************************************;
%*cstutil_cleanupcstsession(
     _cstClearCompiledMacros=0
    ,_cstClearLibRefs=0
    ,_cstResetSASAutos=0
    ,_cstResetFmtSearch=0
    ,_cstResetSASOptions=1
    ,_cstDeleteFiles=1
    ,_cstDeleteGlobalMacroVars=0);