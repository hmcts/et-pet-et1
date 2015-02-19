function ddValue(p_dd)
{
	return p_dd[p_dd.selectedIndex].value;
}

function valueIsUndefined(p_anObject)
{
	return (""+p_anObject.value)=="undefined";
}

function strReplace(p_sourceStr, p_searchStr, p_replaceStr)
{
	var cut=0;
	var l=p_searchStr.length;

	if (p_sourceStr != null)
	{
		while(cut!=-1)
		{
			if((cut=p_sourceStr.indexOf(p_searchStr,0))!=-1)
			{
				p_sourceStr= p_sourceStr.substring(0,cut) + p_replaceStr + p_sourceStr.substring(cut+l,p_sourceStr.length) + "";
			}
		}
	}
	return p_sourceStr;
}

function Convert2Float(f, nbDec)
{
	var i = 0;

	x = 0;
	y = 0;

	for(i = 0; i< f.length;i++)
	{
		if( f.charAt(i) == ',' ) x ++;
		if( f.charAt(i) == '.' ) y ++;
	}

	if (x > 1) {
		f = "";
	}
	if (y > 1) {
		f = "";
	}
	if(x == 1 && y == 0) f = strReplace(f,",",".");

	if(x == 1 && y == 1)
	{
		x = f.indexOf(",");
		y = f.indexOf(".");

		if(x < y) f = strReplace(f,",","");
		if(x > y)
		{
			f = strReplace(f,".","");
			f = strReplace(f,",",".");
		}
	}

	f = "" + parseFloat(f);

	i = f.indexOf(".");
	if(nbDec == 0)
	{
		if(i != -1) f = f.substring(0, i);
	}
	if(nbDec > 0)
	{
		if(i != -1) f = f.substring(0,i+nbDec+1);
		else f += '.';

		i = nbDec - (f.length - f.indexOf(".") - 1);
		while(i > 0)
		{
			f += '0';
			i--;
		}
	}
	if(nbDec < 0)
	{

	}

	if(isNaN(f)) f = "";

	return f;
}

function isNumber(p_str)
{
	var r=parseFloat(p_str);

	if(isNaN(r)) return false;

	if(r==0)
	{
		if(p_str.length==0) return false;
		else
		{
			var l=p_str.length;
			var countZeroes=0;
			var countDecimal=0;

			for(var i=0;i<l;i++)
			{
				if(p_str.charAt(i)=='.') countDecimal++;
				else if(p_str.charAt(i)=='0') countZeroes++;
				}
				if((countZeroes<1) || (countDecimal>1) || (countDecimal+countZeroes != l)) return false;
		}
	}
	return true;
}

function isInt(p_str)
{
	for(var i=0;i<p_str.length;i++)
	{
		if(p_str.charAt(i) < "0" || p_str.charAt(i) > "9") return false;
	}
	return true;
}

function containsNoN(p_str)
{
	for(var i=0;i<p_str.length;i++)
	{
		if(p_str.charAt(i) >= "0" && p_str.charAt(i) <= "9") return false;
	}
	return true;
}

function are2Numbers(p_str)
{
	var m=p_str.indexOf(";",0);
	var first;
	var second;
	if(m==-1) return false;
	first=p_str.substring(0,m);
	second=p_str.substring(m+1,p_str.length);
	if(isNumber(first) && isNumber(second)) return true;
	return false;
}

function xor(a,b)
{
	return a!=b; //( ( a || b) && !(a && b))
}

function FormFieldsA(p_n,p_formName)
{
	for(var i=0; i<p_n; i++)
	{
		this[i]="";
	}
	this.totalFields=p_n;
	this.formName=p_formName;
}

function DependenciesA(p_n)
{
	for(var i=0; i<p_n; i++)
	{
		this[i]="";
	}
	this.totalDependencies=p_n;
}

function FieldDescriptor(p_fieldName, p_fieldLabel, p_fieldType, p_validityExpr, p_dependencies)
{
	this.fieldName=p_fieldName;
	this.fieldLabel=p_fieldLabel;
	this.fieldType=p_fieldType;
	this.validityExpr=p_validityExpr;
	this.dependencies=p_dependencies;
}

function evalFormFields(p_ff)
{
	return evalFormFieldsN(p_ff,0);
}

function isValidEMail(string)
{
	var first;
	var second;
	var last;

	if((last=string.length-1) < 4) return false;

	if( (first=string.indexOf("/",1)) !=-1 ) return false;

	if ((first = string.indexOf("@", 1)) != -1)
	{
		if (((last - first) >= 3) && (second = string.indexOf(".", first + 2)) != -1) return true;
	}
	return false;
}

function isValidUrl(string)
{
	var first;
	var second;
	var last;

	if((last=string.length-1) < 12) return false;
	if( (first=string.indexOf("http",0)) !=-1 )
	{
		if( (last-first) < 12)	return false;
		if( (first=string.indexOf("://",first+4)) !=-1 )
		{
			if( ((last-first) >= 12) && (second=string.indexOf("/",first+8)) !=-1 ) return true;
		}
	}
	return false;
}
function isValidSIC(string)
{
	var l=string.length;

	if(l!=4) return false;
	for(var i=0;i<4;i++)
	{
		c=string.charAt(i);
		if(c<'0' || c>'9') return false;
	}
	return true;
}

function checkCCValid_Short(fieldname) {
	var cnbr;
	var cleancnbr;
	var ilen;
	var ilenclean;
	var oknum;
	var isum;
	var icur;
	var idigit;
	var sdigit;
	var ioddlen;
	var iodd;
	var cchk;
	var myfield;

	myfield = fieldname
	cnbr = myfield.value + "";
	ilen = cnbr.length;
	cleancnbr = "";
	oknum = 0;
	for (var i = 0; i < ilen; i++)
	{
		cchk = cnbr.charAt(i);
		if ((cchk < "0" || cchk > "9")) {
			if (i != (ilen - 1)) {
				if ((cchk) == 'X') {
					oknum = 1;
				break
				}
			}
		}
		else
			cleancnbr = cleancnbr + cchk;
	}
	ilenclean = cleancnbr.length;
	if (ilenclean == 1) {
		oknum = 1;
	}

	if (oknum == 0) {
		isum = 0;
		ilen = cleancnbr.length;
		sdigit = cleancnbr.charAt(ilen - 1);
		idigit = parseInt(sdigit);
		ioddlen = 0;
		if (!((ilen % 2) == 0))
			ioddlen = 1;
		for (var i = 1; i < ilen; i++) {
			cchk = cleancnbr.charAt(i - 1);
			icur = parseInt(cleancnbr.charAt(i - 1));
			iodd = 0;
			if (!((i % 2) == 0))
				iodd = 1;
			if (iodd != ioddlen)
				icur = icur * 2;
			if (icur > 9)
				isum = isum + 1 + (icur - 10)
			else
				isum = isum + icur;
		}
		if (((10 - (isum % 10)) == idigit) || ((0 - (isum % 10)) == idigit))
			oknum = 1;
	}
		return oknum;
}

function checkCCValid(fieldname)
{
	var cnbr;
	var cleancnbr;
	var ilen;
	var ilenclean;
	var oknum;
	var isum;
	var icur;
	var idigit;
	var sdigit;
	var ioddlen;
	var iodd;
	var cchk;
	var myfield;

	myfield = fieldname
	cnbr = myfield.value + "";
	ilen = cnbr.length;
	cleancnbr="";
	oknum = 0;
	for(var i=0;i<ilen;i++)
	{
		cchk = cnbr.charAt(i);
		if((cchk < "0" || cchk > "9"))
		{
			if (i!=(ilen - 1))
			{
				if ((cchk)=='X')
				{
					oknum = 1;
					break
				}
			}
		}
		else
			cleancnbr = cleancnbr + cchk;
	}
	ilenclean = cleancnbr.length;
	ilenclean = cleancnbr.length;
	if ((ilenclean==8)||(ilenclean==9))
	{
		oknum=1;
	}

	if (oknum == 0)
	{
		isum = 0;
		ilen = cleancnbr.length;
		sdigit = cleancnbr.charAt(ilen - 1);
		idigit = parseInt(sdigit);
		ioddlen = 0;
		if (!((ilen%2)==0))
			ioddlen = 1;
		for(var i=1;i<ilen;i++)
		{
			cchk = cleancnbr.charAt(i-1);
			icur = parseInt(cleancnbr.charAt(i - 1));
			iodd = 0;
			if (!((i%2)==0))
				iodd = 1;
			if (iodd!=ioddlen)
				icur = icur * 2;
			if (icur > 9)
				isum = isum + 1 + (icur - 10)
			else
				isum = isum + icur;
		}
		if (((10-(isum%10))==idigit) || ((0-(isum%10))==idigit))
			oknum=1;
	}
	return oknum;
}

function my_submitAndDisable(thisform,limitScriptU)
{
	var RC;

	if (typeof fillHdJs != 'undefined')
	{
		fillHdJs();
	}

	if (typeof formFields != 'undefined')
	{
		RC = evalFormFieldsN(formFields,limitScriptU);
	}
	else
	{
		RC = true;
	}
	if (RC)
	{
		for (i = 0; i < thisform.elements.length; i++)
		{
			if (thisform.elements[i].type == "submit")
			{
				thisform.elements[i].disabled = true;
			}
		}
	}
	return RC;
}

function my_submit()
{
	var RC;

	if (typeof fillHdJs != 'undefined')
	{
		fillHdJs();
	}
	if (typeof formFields != 'undefined')
	{
		RC = evalFormFields(formFields);
	}
	else
	{
		RC = true;
	}
	return RC;
	//	return evalFormFields(formFields);
}

function getInfoBrandFromCardNb(strCardNb)
{
	var strBrand;
	var iCVCLength, i;
	var chIdent;
	var oInfoBrand;

	chIdent =  "";
	strBrand = "";
	iCVCLength = 0;
	if (strCardNb.length > 2)
	{
		if (strCardNb.length ==11)
		{
			if ((strCardNb.charAt(0)=="1") || (strCardNb.charAt(0)=="2") || (strCardNb.charAt(0)=="3") || (strCardNb.charAt(0)=="4") || (strCardNb.charAt(0)=="9"))
			{
				strBrand = "Aurora";
				iCVCLength=8;
			}
		}
		else
		{
			i = 0;
			chIdent = strCardNb.charAt(0);
			switch(chIdent){
				case "4":
					strBrand = "VISA";
					iCVCLength=3;
					break;
				case "3":
					if ((strCardNb.charAt(1) == "6") || (strCardNb.charAt(1) == "8"))
					{
						strBrand = "Diners Club";
					}
				else
				{
					if (strCardNb.substring(0,6) == "377451")
					{
						strBrand = "Club Med";
						iCVCLength=4;
					}
					else
					{
						if ((strCardNb.charAt(1) == "4") || (strCardNb.charAt(1) == "7"))
						{
							chIdent = chIdent + strCardNb.charAt(1);
							strBrand = "American Express";
							iCVCLength=4;
						}
						if (strCardNb.length > 12)
						{
							if ((chIdent == "37") && (strCardNb.substring(11,14) == "199"))
							strBrand = strBrand + " CPC";
						}
					}
				}
				break;
					case "5":
					if (strCardNb.charAt(1) == "1")
						strBrand = "Eurocard";
					if (strCardNb.charAt(1) == "2")
						strBrand = "Eurocard";
					if (strCardNb.charAt(1) == "3")
						strBrand = "Eurocard";
					if (strCardNb.charAt(1) == "4")
						strBrand = "Eurocard";
					if (strCardNb.charAt(1) == "5")
						strBrand = "Eurocard";
					if (strCardNb.substring(0,6) == "588639")
					{
						if  (strCardNb.substring(16,18) == "01")
						{
							strBrand = "Kangourou";
						}
						else if  (strCardNb.substring(16,18) == "13")
						{
							strBrand = "Cyrillus";
						}
						else if  (strCardNb.substring(16,18) == "21")
						{
							strBrand = "Surcouf";
						}
						else if  (strCardNb.substring(16,18) == "27")
						{
							strBrand = "OKShopping";
						}
						else if  (strCardNb.substring(16,18) == "28")
						{
							strBrand = "Go Sport";
						}
						else if  (strCardNb.substring(16,18) == "23")
						{
							strBrand = "Mandarine";
						}
					}
					if (strCardNb.substring(0,6) == "588656")
					{
						strBrand = "FNAC";
					}
					if (strCardNb.substring(0,6) == "501637")
					{
						strBrand = "Printemps";
					}
					if (strCardNb.substring(0,6) == "525444")
					{
						strBrand = "Billy";
					}
					if (strBrand.length>0 && strBrand!="Cyrillus")
					iCVCLength=3;
					break;
					case "0":
					if (strCardNb.substring(1,3) == "61")
					{
						strBrand = "Aurora";
					}
					break;
				case "6":
					if ((strCardNb.substr(0,4) == "6767" ) || (strCardNb.substr(0,4) == "6334" ) )
					{
						strBrand = "Solo";
					}
					else if ((strCardNb.substr(0,6) == "630487") || (strCardNb.substr(0,6) == "630488") ||
									(strCardNb.substr(0,6) == "630490") || (strCardNb.substr(0,6) == "630491") ||
									(strCardNb.substr(0,6) == "630493") || (strCardNb.substr(0,6) == "630494") || (strCardNb.substr(0,6) == "630495") || (strCardNb.substr(0,6) == "630496") ||
									(strCardNb.substr(0,6) == "630499") || (strCardNb.substr(0,6) == "630500") ||
									(strCardNb.substr(0,6) == "670695") || (strCardNb.substr(0,6) == "670696"))
					{
						strBrand = "Laser";
						iCVCLength = 3;
					}
					else if (strCardNb.length == 16)
					{
						strBrand = "Discover";
						iCVCLength = 3;
					}
					break;
				case "X":
					// from cardalias, need to retrieve brand in hidden fields (ChosenBrand)
					strBrand = document.getElementById('ChosenBrand').value;
					switch(strBrand)
					{
						case "VISA":
							iCVCLength=3;
							break;
						case "American Express":
							iCVCLength=4;
							break;
						case "Eurocard":
							iCVCLength=3;
							break;
						case "Club Med":
							iCVCLength=4;
							break;
						case "Aurora":
							iCVCLength=8;
							break;
						case "Discover":
							iCVCLength=3;
						default:
					}
					break;
				default:
			}
		}
	}
	oInfoBrand = {cvclen:iCVCLength , brand:strBrand};
	return oInfoBrand;
}

function Is_cvcOK(cvcfield,cnbrFld)
{
	var oInfoBrand;
	var strBrandUpper, strCardNb, strCVCVal, strNumCVCVal;
	var iCVCLen, i, OK;

	strCardNb = cnbrFld.value + "";

	oInfoBrand = getInfoBrandFromCardNb(strCardNb);
	strBrandUpper = oInfoBrand.brand.toUpperCase();
	iCVCLen = oInfoBrand.cvclen;

	strCVCVal = cvcfield.value + "";
	strNumCVCVal = strCVCVal.replace(/\//g,"");
	OK = 0;
	if (strNumCVCVal.length > 0)
	{
		OK = 1;
		for(i=0 ; i<strNumCVCVal.length ; i++)
		{
			if(strNumCVCVal.charAt(i) < "0" || strNumCVCVal.charAt(i) > "9")
			{
				OK = 0;
			}
		}
	}
	if (iCVCLen > 0 && OK == 1)
	{
		if (strNumCVCVal.length != iCVCLen)
		{
			OK = 2;
		}
	}
	return OK;
}


function evalFormFieldsN(p_ff,lsu)
{
	var thisField;
	var validity;
	var resf;
	var idMSG;
	var ErrSpan;
	var bUseSpan;
	var AlertMSG="";
	for(var i=0; i<p_ff.totalFields; i++)
	{
		thisField=p_ff.formName +"." +p_ff[i].fieldName;
		validity = strReplace(p_ff[i].validityExpr, "$$FO", "" + p_ff.formName);
		validity=strReplace(validity,"$$FI",""+p_ff[i].fieldName);
		validity = strReplace(validity, "$$F", thisField);
		if (document.getElementsByName(formFields[i].fieldName).length > 0)
		{
			if (lsu == 1)
			{
				idMSG = "idErrMSG"+p_ff[i].fieldName;
				ErrSpan = document.getElementById(idMSG);
				if (ErrSpan != 'undefined')
				{
					ErrSpan.innerHTML = "";
				}
			}
			//test validity
			resf = eval("(" + validity + ")");
			if ((resf & 1) == 0)
			//		if(0==eval("("+ validity +") ? 1 : 0"))
			{
				if(p_ff[i].fieldType=="T")
				{
					AlertMSG = AlertMSG_109 + ": '"+p_ff[i].fieldLabel+"'";
					eval(thisField +".focus()");
					//				eval(thisField +".select()");
				}
				else if(p_ff[i].fieldType=="TS")
				{
					AlertMSG = AlertMSG_110 + ": '"+p_ff[i].fieldLabel+"'";
					eval(thisField +".focus()");
					//	eval(thisField +".select()");
				}
				else if(p_ff[i].fieldType=="TZ")
				{
					AlertMSG = "You are not obliged to fill the '"+p_ff[i].fieldLabel+"' field, " + "but if you do, do it right (please, see Help)";
					eval(thisField +".focus()");
					eval(thisField +".select()");
				}
				else if(p_ff[i].fieldType=="TN")
				{
					if (resf == 0)
					{
						AlertMSG = AlertMSG_173 + ": '" + p_ff[i].fieldLabel + "'";

					}
					else if (resf == 2)
						{
							AlertMSG = AlertMSG_1205 + ": '" + p_ff[i].fieldLabel + "'";
							eval(thisField +".focus()");
							eval(thisField +".select()");
						}
				}
				else if(p_ff[i].fieldType=="TNZ")
				{
					AlertMSG = "You are not obliged to fill the '"+p_ff[i].fieldLabel+"' field, " + "but if you do, must enter a number in the "+p_ff[i].fieldLabel+" field, please.";
					eval(thisField +".focus()");
					eval(thisField +".select()");
				}
				else if(p_ff[i].fieldType=="R")
				{
					AlertMSG = p_ff[i].fieldLabel;
					//eval(thisField +"[0].focus()"); //Not supported by IE
					//eval(thisField +"[0].select()");//Not supported by IE
				}
				else if(p_ff[i].fieldType=="TV") // for hidden field, no focus
				{
					AlertMSG = AlertERR_907 + ": '" + p_ff[i].fieldLabel + "'";
					//				if (eval(thisField+".name")=="Comp_Expirydate")
					//				{
					//					AlertMSG = AlertMSG + "\nMonth:" + document.OGONE_CC_FORM.Ecom_Payment_Card_ExpDate_Month.options[document.OGONE_CC_FORM.Ecom_Payment_Card_ExpDate_Month.selectedIndex].value;
					//					AlertMSG = AlertMSG + "\nYear:" + document.OGONE_CC_FORM.Ecom_Payment_Card_ExpDate_Year.options[document.OGONE_CC_FORM.Ecom_Payment_Card_ExpDate_Year.selectedIndex].value;
					//					AlertMSG = AlertMSG + "\n(" +eval(thisField+".value")+"/"+ validity+")";
					//					}

				}
				else if(p_ff[i].fieldType=="TC") // for checkGSM, checkcard => not valid
				{
					AlertMSG = AlertERR_907 + ": '" + p_ff[i].fieldLabel + "'";
					eval(thisField +".focus()");
					eval(thisField +".select()");
				}
				else if(p_ff[i].fieldType=="TD")
				{
					// Dynamic : only fieldlabel
					//				alert(p_ff[i].fieldLabel);
					AlertMSG = p_ff[i].fieldLabel;
					eval(thisField +".focus()");
					eval(thisField +".select()");
				}
				else if (p_ff[i].fieldType == "RB") {	// For radio buttons
					AlertMSG = AlertMSG_110 + ": '" + p_ff[i].fieldLabel + "'";
					eval(thisField + "[0].focus()");
				}

				if (AlertMSG.length>0)
				{
					//				alert('lsu: ' + lsu);
					if (lsu == 1)
					{
						ErrSpan.innerHTML = AlertMSG;
					}
					else
					{
						alert(AlertMSG);
					}
				}

				return false;
			}
			//test dependencies

			if(p_ff[i].dependencies != null && ( eval( "("+thisField+".value !='') ? 1 : 0")==1 ) )
			{
				for(var j=0; j<p_ff[i].dependencies.totalDependencies; j++)
				{
					if( eval( "("+p_ff.formName+"." + p_ff[p_ff[i].dependencies[j]].fieldName+".value =='')? 1 : 0")==1 )
					{
						AlertMSG = "If you fill the "+p_ff[i].fieldLabel +" field, " + "the "+p_ff[p_ff[i].dependencies[j]].fieldLabel + " field must also be filled.";
						if (lsu == 1)
						{
							ErrSpan.innerHTML = AlertMSG;
						}
						else
						{
							alert(AlertMSG);
						}
						//					alert("If you fill the "+p_ff[i].fieldLabel +" field, " + "the "+p_ff[p_ff[i].dependencies[j]].fieldLabel + " field must also be filled.");
						return false; //could accumulate field names...
					}
				}
			}
		}
	}
	return true;
}

function checkEMail()
{
	if((document.myform.Email.value!="") && ! isValidEMail(document.myform.Email.value))
	{
		alert(AlertMSG_111);
		window.setTimeout(function() {
			document.myform.Email.focus();
			document.myform.Email.select();
		}, 100);
	}
}

function checkEmailInput(txt_input) {
	if (typeof txt_input === "object")
	{
		if (txt_input.tagName.toLowerCase() === "input")
		{
			var value = txt_input.value;
			if (value != "" && !isValidEMail(value))	{
				alert(AlertMSG_111);
				//Needs a timeout because once the onChange function finishes it sets focus to the next element.
				//So any focus you set in the function will be overridden after the onChange ends.
				window.setTimeout(function () {
					txt_input.focus();
					txt_input.select();
				}, 100);
			}
		}
	}
}

function checkEMailECML()
{
	if((document.myform.Ecom_ShipTo_Online_Email.value!="") && ! isValidEMail(document.myform.Ecom_ShipTo_Online_Email.value))
	{
		alert(AlertMSG_111);
		document.myform.Ecom_ShipTo_Online_Email.focus();
		document.myform.Ecom_ShipTo_Online_Email.select();
	}
}

function checkCVCAndPresInd(oCVC, oCVCFlag, oCardNb)
{
	var iResult;
	var oInfoBrand, oCardNb;
	var ErrSpan;
	var idMSG;
	var f_G_lsu;
	if (G_lsu=undefined)
	{f_G_lsu = 0;}
	else
	{f_G_lsu = G_lsu;}
	if (f_G_lsu == 1){
		idMSG = "idErrMSG"+oCVC.name;
		ErrSpan = document.getElementById(idMSG);
	}
	oInfoBrand = getInfoBrandFromCardNb(oCardNb.value);

	iResult = 1;
	if (arrDispCVCFlag.indexOf("#" + oInfoBrand.brand.toUpperCase() + "#") != - 1)
	{
		if (oCVC.value.length > 0)
		{
			if ((oCVCFlag.value != 1) && (oCVCFlag.value != -1))
			{
				if (f_G_lsu == 1){
					ErrSpan.innerHTML = AlertERR_95;
				}
				else
				{
					alert(AlertERR_95);
				}
				return 4;
			}
			else
			{
				return Is_cvcOK(oCVC,oCardNb);
			}
		}
		else
		{
			if ((oCVCFlag.value == 1)
			|| ((oCVCFlag.value == -1 || oCVCFlag.value == 0) && (arrcvc.indexOf("#" + oInfoBrand.brand.toUpperCase() + "#")!= - 1)))
			{
				if (f_G_lsu == 1 && ErrSpan!= 'undefined' ){
					ErrSpan.innerHTML = AlertERR_96;
				}
				else
				{
					alert(AlertERR_96);
				}
				return 4;
			}
		}
	}
	else
	{
		if (arrcvc.indexOf("#" + oInfoBrand.brand.toUpperCase() + "#")!= - 1)
		{
			return Is_cvcOK(oCVC,oCardNb);
		}
	}
	return iResult;
}