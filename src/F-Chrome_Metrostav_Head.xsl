<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/TR/REC-html40">
  <INFO>
    <SUBJECT>Faktura Metrostav head</SUBJECT>
    <AUTHOR>O.Hobl</AUTHOR>
    <EMAIL>hobl@hoblapech.cz</EMAIL>
    <VERSION>1.00</VERSION>
  </INFO>
  <ORIGIN>
    <PODNIK>Metrostav a.s.</PODNIK>
    <DATE>17.10.2020</DATE>
    <SESTAVAN>1</SESTAVAN>
    <POPIS>
      Faktura Chrome pro firmu Metrostav pouze hlavička pro PDF
    </POPIS>
    <HIST>
      17.12.2007 - první pokus s fakturou dle dodaneho vzoru.
      29.10.2020 - zjednodušená verze be jednotlivych řádek FAKTURY
                   na jednu stránku v kódování UTF-8 bom

    </HIST>
  </ORIGIN>

  <xsl:output method="html" encoding="windows-1250"/>
  <!--                 nezobrazovane udaje                 -->
  <xsl:template match="text()"/>

  <!-- ladici tisk -->
  <xsl:variable name="debug" select="0"/>
  <!-- pocet radek vykonu na prvni strance s patou -->
  <xsl:variable name="radek1" select="10"/>
  <!-- pocet radek vykonu na prvni strance bez paty -->
  <xsl:variable name="radek1bezp" select="18"/>

  <!-- pocet radek na strance s patou -->
  <xsl:variable name="radekn" select="25"/>
  <!-- pocet radek na strance bez paty -->
  <xsl:variable name="radeknbezp" select="34"/>

  <!-- celkovy pocet radek -->
  <xsl:variable name="pocetr" select="count(//FER) + count(//FEH)"/>

  <!-- pocet radek na posledni strane -->
  <xsl:variable name="lastpr">
    <xsl:choose>
      <xsl:when test="$pocetr &gt; $radek1bezp">
        <xsl:value-of select="floor(($pocetr - $radek1bezp) mod $radeknbezp)"/>
      </xsl:when>
      <xsl:otherwise>
        <!-- mame jen prvni stranu -->
        <xsl:value-of select="$pocetr"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- posledni stranka se testuje proti   -->
  <xsl:variable name="radektest">
    <xsl:choose>
      <xsl:when test="$pocetr &gt; $radek1bezp">
        <xsl:value-of select="$radekn"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$radek1"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <!-- posledni stranka se doplnuje na pocet radek :  -->
  <xsl:variable name="radektestbezp">
    <xsl:choose>
      <xsl:when test="$pocetr &gt; $radek1bezp">
        <xsl:value-of select="$radeknbezp"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$radek1bezp"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- pocet stranek celkem ? ? ?  ?  ? ***************  -->
  <xsl:variable name="stran">
    <xsl:choose>
      <xsl:when test="$pocetr &lt;= $radek1">
        <!--  -->
        <xsl:value-of select="1"/>
      </xsl:when>
      <xsl:when test="$pocetr &lt;= $radek1bezp">
        <!--  -->
        <xsl:value-of select="2"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$lastpr &gt; $radektest">
            <!-- + odstrankovani na patu -->
            <xsl:value-of select="floor(($pocetr - $radek1bezp) div $radeknbezp) + 3"/>
          </xsl:when>
          <xsl:otherwise>
            <!-- bez odstrankovani na patu -->
            <xsl:value-of select="floor(($pocetr - $radek1bezp) div $radeknbezp) + 2"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <!--  -->


  <xsl:template match="/">
    <html>
      <head>
        <META content="text/html" charset="UTF-8" http-equiv="Content-Type"/>
        <META content="cs" http-equiv="Content-language"/>
        <title>Faktura - MIS</title>

        <style>
* { margin: 0; padding: 0; }

body{ 
	font-size: 10pt;
	background-color:white;
	font-family : "Arial", "MS Serif", "New York", serif;
}

#mainrambot { width: 800px; margin: 0 auto; }

textarea { border: 0; font: 14px Georgia, Serif; overflow: hidden; resize: none; }

table { border-collapse: collapse; }
table td, table th { border: 1px solid black; padding: 5px; }

#header { height: 15px; width: 100%; margin: 20px 0; background: #222; text-align: center; color: white; font: bold 15px Helvetica, Sans-Serif; text-decoration: uppercase; letter-spacing: 20px; padding: 8px 0px; }


#logo { text-align: left; position: relative; margin-top: 5px;
	display: block;	
	border: 1px solid #fff; max-height: 100px; overflow: hidden; }


	#doklad { font-size: 12px; width: 600px; text-align: center; margin-left: 1px;  }
	.evc { font-size: 12px; width: 200px; text-align: center; margin-left: 200px;  }
	 
	.podtr {vertical-align: top; text-decoration: underline;}
	.icodico {width: 170px; display:inline-block; margin-left: 110px;}
		.icodico dt {width: 30%;text-align: left; display:inline-block;}
		.icodico dd {width: 60%;text-align: left; display:inline-block;}
	.ustav {display:inline-block; width: 100mm;}
		.ustav dt {width: 30%;text-align: left; display:inline-block;}
		.ustav dd {width: 60%;text-align: left; display:inline-block;}
	.forma {display:inline-block; width: 100mm;}
		.forma dt {width: 60%;text-align: left; display:inline-block;}
		.forma dd {width: 30%;text-align: left; display:inline-block;}


	.address { font-weight: bold; width: 100mm; }
	.textzapis {
		font-size: 8pt;
		margin-top:10mm;
		text-align : left;
		}
#meta { margin-top: 1px; width: 300px; float: right; }
#meta td { text-align: right;  }
#meta td.meta-head { text-align: left; background: #eee; }
#meta td textarea { width: 100%; height: 20px; text-align: right; }

#tablehead { clear: both; width: 100%; margin: 3px 0 0 0; border: 1px solid black; }
#telohead { clear: both; width: 100%; margin: 3px 0 0 0; border: 1px solid black; }
#pata { clear: both; width: 100%; margin: 3px 0 0 0; border: 1px solid black; }

#foot { clear: both; width: 100%; margin: 30px 0 0 0; border: 1px solid black; }



.noborder {border: 0; vertical-align:top;}
.leftborder {border:0; border-left: solid 1px black; vertical-align:top;}
.topborder {border:0; border-top: solid 1px black; vertical-align:top;}
.textright {text-align: right;	}
.textcenter {text-align: center;}

.zazh {display:inline-block; width: 50%; margin-top: 20mm;}
.zaob {display:inline-block; width: 50%; margin-top: 20mm; }
.razitko {margin-top: 8mm;}

        </style>

      </head>
      <body>
        <DIV id="mainrambot">
          <div id="logo">
            <IMG src="logo.jpg" width="140px" height="80px"/>
          </div>

          <div id="doklad">
            DAŇOVÝ DOKLAD
            <span class="podtr evc">
              evid.č:
              <xsl:value-of select="//CISF"/>
            </span>
          </div>

          <xsl:if test="$debug = 1">
            <br/>
            <div>
              pocetr=
              <xsl:value-of select="$pocetr"/>
              lastpr:
              <xsl:value-of select="$lastpr"/>
              radektest:
              <xsl:value-of select="$radektest"/>
              stran:
              <xsl:value-of select="$stran"/>
            </div>
            <br/>
          </xsl:if>
          <xsl:call-template name="hlava">
          </xsl:call-template>

          <!-- Vykonove redky zde nepouzijeme 
          <xsl:call-template name="telohead">
          </xsl:call-template>
          -->
          <!-- xsl:apply-templates/>  -->
 

        <!-- a nakonec dame paticku  -->
        <xsl:call-template name="pata">
        </xsl:call-template>
       
       
       </DIV>

      </body>
    </html>
  </xsl:template>




  <!-- **************************************************************** -->
  <!--     casti stranky    -->
  <xsl:template name="hlava">
    <table id="tablehead">
      <TR>
        <TD>
          <span class="podtr">Zhotovitel:</span>

          <dl class="icodico">
            <dt>IČ:</dt>
            <dd>
              <xsl:value-of select="//ORIGIN/ICO"/>
            </dd>
            <dt>DIČ:</dt>
            <dd>
              <xsl:value-of select="//ORIGIN/DICO"/>
            </dd>
          </dl>

          <dl class="address">
            <dt>
              <xsl:value-of select="//ORIGIN/NAZEVDOADRESY"/>
            </dt>
            <dt>
              <xsl:value-of select="//ORIGIN/A1"/>
            </dt>
            <dt>
              <xsl:value-of select="//ORIGIN/A3"/>
              ,
              <xsl:value-of select="//ORIGIN/A2"/>
            </dt>
          </dl>

          <dl class="ustav">
            <dt>Peněžní ústav :</dt>
            <dd>KB Praha 7</dd>
            <dt>číslo účtu :</dt>
            <dd>1809071 / 0100</dd>
            <dt style="width:5em;">IBAN:</dt>
            <dd style="width:15em;">CZ19 0100 0000 0000 0180 9071</dd>
          </dl>
          <DIV class="textzapis">Zápis do OR - Městský soud v Praze, odd. B vl. 17819</DIV>
        </TD>
        <TD>
          <span class="podtr">
            <B>Objednatel:</B>
          </span>
          <dl class="icodico">
            <dt>IČ:</dt>
            <dd>
              <xsl:value-of select="substring(//MATERMASO,1,8)"/>
            </dd>
            <dt>DIČ:</dt>
            <dd>
              <xsl:value-of select="//DICOTX"/>
            </dd>
          </dl>
          
          <dl class="address">
            <dt>
              <xsl:value-of select="//FAKTURA/FAH/OBJEDNAZEV"/>
            </dt>
            <dt> 
              Divize -
              <xsl:value-of select="substring(//FAKTURA/RADKY/FEH/OBJEDMASO,1,2)"/>
              -
              <xsl:value-of select="substring(//FAKTURA/RADKY/FEH/OBJEDMASO,1,8)"/>
            </dt>
            
            <xsl:if test="string-length(//O1)">
            <dt>  <xsl:value-of select="//O1"/></dt>   
            </xsl:if>
            <xsl:if test="string-length(//O2)">
            <dt><xsl:value-of select="//O2"/></dt>
              
            </xsl:if>
            <xsl:if test="string-length(//O3)">
              <dt><xsl:value-of select="//O3"/></dt>
              
            </xsl:if>
            <xsl:if test="string-length(//O4)">
              <dt><xsl:value-of select="//O4"/></dt>
              
            </xsl:if>
            <xsl:if test="string-length(//O5)">
              <dt><xsl:value-of select="//O5"/></dt>
              
            </xsl:if>
          
          </dl>
        </TD>
      </TR>
      <TR>
        <TD>
         <dl class="forma">
          <dt>Forma úhrady:</dt>
          <!--  -->
          <dd>Příkaz k úhradě</dd>

          <dt>Den splatnosti:</dt>
          <!-- zmena americkeho datumu nas cesky  -->
          <xsl:variable name="ds" select="//DS" />
          <dd>
            <xsl:value-of select="concat(substring($ds,4,2),'.',substring($ds,1,2),'.',substring($ds,7,4))" />
          </dd>

          <dt>Den vystavení:</dt>
          <!-- zmena americkeho datumu nas cesky  -->
          <xsl:variable name="df" select="//DF" />
          <dd>
            <xsl:value-of select="concat(substring($df,4,2),'.',substring($df,1,2),'.',substring($df,7,4))" />
          </dd>

          <dt>
            <xsl:text>Datum uskutečnění plnění:</xsl:text>
          </dt>
          <!-- zmena americkeho datumu nas cesky  -->
          <xsl:variable name="dzp" select="//DZP" />
          <dd>
            <xsl:value-of select="concat(substring($dzp,4,2),'.',substring($dzp,1,2),'.',substring($dzp,7,4))" />
          </dd>
        </dl>
        </TD>
        <TD>
          <DIV class="text40">Způsob dopravy :</DIV>
          <DIV class="text40"/>
          <DIV class="text40">Místo vyskladnění :</DIV>
          <DIV class="text40"/>
          <DIV class="text40">Místo určení :</DIV>
          <DIV class="text40"/>
          <DIV class="text40">Dodací list č.:</DIV>
          <DIV class="text40"/>
        </TD>
      </TR>
      <TR>
        <TD class="noborder">
          Vaše objednávka (smlouva) č. :
          <br/>
          <xsl:value-of select="//FAKTURA/FAH/INFO1"/>
        </TD>
        <TD class="noborder">
          <DIV class="textobj">ze dne:</DIV>
          <br/>
          <xsl:value-of select="//FAKTURA/FAH/CISLOOBJEDNAVKY"/>
        </TD>
      </TR>
    </table>
  </xsl:template>

  <!-- ***************************************************** -->
  <xsl:template name="telohead">
    <table id="telohead">
      <THEAD>
        <TR>
          <TD>Rozsah a předmět plnění SKP</TD>
          <TD>Sazba DPH</TD>
          <TD>Mj</TD>
          <TD>Množství</TD>
          <TD>jedn.cena</TD>
          <TD>Úhrnná částka základu daně</TD>
        </TR>
      </THEAD>
      <TBODY>
        <xsl:for-each select="//FEH">
          <xsl:call-template name="stazka">
            <xsl:with-param name="uvodtext" select="''"/>
          </xsl:call-template>

          <xsl:for-each select="FER">
                <!-- test odstrankovani pred FER musime pripocitat jeden FEH blbe
                <xsl:call-template name="testpage">
                <xsl:with-param name="pcr" select="$pcr+position()"/>
                  </xsl:call-template>
                -->
            <!-- vypis jedne radky vykonu -->
            <xsl:call-template name="vykony"/>
          </xsl:for-each>
        </xsl:for-each>

        <!-- posledni stranku doplnime prazdnymi radkami -->
        <xsl:if test="$lastpr &gt; $radektest">
          <xsl:call-template name="vykonprazdny">
            <xsl:with-param name="pocet" select="$radektestbezp - $lastpr"/>
          </xsl:call-template>
          <!-- a odstrankujem pred patou -->
          <xsl:call-template name="newpagepata">
            <xsl:with-param name="numpage" select="$stran"/>
          </xsl:call-template>
        </xsl:if>
       <!-- pocet radek na posledni strance je mensi nez $radekn nebo $radek1-->
        <xsl:if test="$lastpr &lt; $radektest">
          <!-- doplnime prazdne radky a neodstrankujeme -->
          <xsl:call-template name="vykonprazdny">
            <xsl:with-param name="pocet" select="$radektest - $lastpr"/>
          </xsl:call-template>
        </xsl:if>

      </TBODY>
    </table>
  </xsl:template>


  <!--   *************************************************************    -->
  <xsl:template name="pata">
    <table id="pata">
      <TR>
        <TD colspan="4" class="textcenter">Celkem Kč bez daně z přidané hodnoty :</TD>
        <TD class="textright">
         <span >
          <xsl:value-of select="format-number(sum(//SOUCTYDPH/FAD/ZAKLAD),  '#######0.00')"/>
          <xsl:text/>
          <xsl:value-of select="//FAKTURA/FAH/MENAZKRATKA"/>
          </span>
        </TD>
      </TR>
      <TR>
      <TD colspan="4"  class="textcenter">
         Plnění osvobozené od daně podle § .... zákona o DPH:
        </TD>
        <TD class="textright">
          <xsl:value-of select="format-number(//SOUCTYDPH/FAD[KODDPH_DMD='NULOVA']/ZAKLAD,  '#######0.00')"/>
          <xsl:text/>
          <xsl:value-of select="//FAKTURA/FAH/MENAZKRATKA"/>

      </TD>
      </TR>
      <TR>

          <TD>Snížená sazba</TD>
          <TD>Základ daně :</TD>
          <TD class="textright">
            <xsl:value-of select="format-number(//SOUCTYDPH/FAD[KODDPH_DMD='SNIZEN']/ZAKLAD,  '#######0.00')"/>
            <xsl:text/>
            <xsl:value-of select="//FAKTURA/FAH/MENAZKRATKA"/>
          </TD>
          <TD class="textright">DPH:</TD>
        
        <TD>
          <xsl:value-of select="format-number(//SOUCTYDPH/FAD[KODDPH_DMD='SNIZEN']/DAN,  '#######0.00')"/>
          <xsl:text/>
          <xsl:value-of select="//FAKTURA/FAH/MENAZKRATKA"/>
      </TD>
      </TR>
      <TR>
          <TD class="patatextsazba">Základní sazba</TD>
          <TD class="patatextzaklad">Základ daně:</TD>
          <TD class="textright">
            <xsl:value-of select="format-number(//SOUCTYDPH/FAD[KODDPH_DMD='ZAKLAD']/ZAKLAD,  '#######0.00')"/>
            <xsl:text/>
            <xsl:value-of select="//FAKTURA/FAH/MENAZKRATKA"/>
          </TD>
          <TD class="textright">DPH:</TD>
        
         <TD class="textright">
          <xsl:value-of select="format-number(//SOUCTYDPH/FAD[KODDPH_DMD='ZAKLAD']/DAN,  '#######0.00')"/>
          <xsl:text/>
          <xsl:value-of select="//FAKTURA/FAH/MENAZKRATKA"/>
         </TD>
      </TR>
      <TR>
      <TD colspan="4"  class="textcenter">
          CELKOVÁ ČÁSTKA FAKTURY S DPH K ÚHRADĚ :
      </TD>
      <TD class="textright">    
          <xsl:value-of select="format-number(//FAKTURA/FAH/KUHRADE,'#########0.00')"/>
          <xsl:text/>
          <xsl:value-of select="//FAKTURA/FAH/MENAZKRATKA"/>
      </TD>
      </TR>
      </table>


      
      <div class="zazh">
      <div>
        Za zhotovitele:&#160;&#160;&#160;
        <xsl:value-of select="//FAKTURA/FAH/FAKTURANT"/>
      </div>  
      <div> 
        Telefon/fax:  &#160;&#160;&#160;&#160;&#160;&#160;&#160;
        <xsl:value-of select="//FAKTURA/FAH/TELEFON"/>
        <xsl:if test="string-length(//FAKTURA/FAH/UZIV_FAX) &gt; 1">
          /
          <xsl:value-of select="//FAKTURA/FAH/UZIV_FAX"/>
        </xsl:if>
        </div>
        <div class="razitko">
        Razítko:
        </div>
        <div>Podpis:</div>
        
        <br/>
        Datum:
        <xsl:value-of select="concat(substring(//FAKTURA/FAH/DF,4,2),'.',substring(//FAKTURA/FAH/DF,1,2),'.',substring(//FAKTURA/FAH/DF,7,4))" />

      </div>

      <div class="zaob">
      <div>
        Za objednatele:&#160;&#160;&#160;
        
      </div>  
      <div> 
        Telefon/fax:
        </div>
        <div class="razitko">
        Razítko:
        </div>
        <div>Podpis:</div>
        
        <br/>
        Datum:
      
    </div>

  </xsl:template>



  <!-- vypis dat ze zahlavi FEH  -->
  <xsl:template name="stazka">
    <xsl:param name="uvodtext" select="' '"/>
    <TR>
      <TD class="topborder">
        <xsl:choose>
          <xsl:when test="string-length($uvodtext) &gt; 1 ">
            <xsl:value-of select="$uvodtext"/>
          </xsl:when>
          <xsl:otherwise>
            Dne:
            <xsl:variable name="d" select="DATUMPOCATKU" />
            <xsl:value-of select="concat(substring($d,4,2),'.',substring($d,1,2),'.',substring($d,9,2))" />
            :
            <xsl:value-of select="SPZ"/>
            -
            <xsl:value-of select="DZNAZ"/>
          </xsl:otherwise>
        </xsl:choose>
      </TD>
      <TD class="dphd leftborder">
      </TD>
      <TD class="mjd leftborder">
      </TD>
      <TD class="mnd leftborder">
      </TD>
      <TD class="jcd leftborder">
      </TD>
      <TD class="ucd leftborder">
      </TD>
    </TR>
    <!--  -->
  </xsl:template>


  <xsl:template name="vykony">
    <TR class="vykon">
      <TD class="poznd noborder">
        <xsl:value-of select="POPIS"/>
      </TD>
      <TD class="dphd leftborder">
        <xsl:value-of select="format-number(DPH,'########0.00')"/>
      </TD>
      <TD class="mjd leftborder">
        <xsl:value-of select="JEDNOTKA"/>
      </TD>
      <TD class="mnd leftborder">
        <xsl:value-of select="format-number(POCETJED,'#######0.00')"/>
      </TD>
      <TD class="jcd leftborder">
        <xsl:value-of select="format-number(SAZBA,'#######0.00')"/>
      </TD>
      <TD class="ucd leftborder">
        <xsl:value-of select="format-number(KC,'#######0.00')"/>
      </TD>
    </TR>
  </xsl:template>

  <!-- prazdna radka vykonu - pro vyplneni mista na strance  -->
  <xsl:template name="vykonprazdny">
    <xsl:param name="pocet" select="1"/>
    <xsl:if test="$pocet &gt; 0">
      <TR class="vykon">
        <TD class="poznd noborder">pocet=<xsl:value-of select="$pocet"/>
        </TD>
        <TD class="dphd leftborder">
        </TD>
        <TD class="mjd leftborder">
        </TD>
        <TD class="mnd leftborder">
        </TD>
        <TD class="jcd leftborder">
        </TD>
        <TD class="ucd leftborder">
        </TD>
      </TR>
      <!--  -->
      <xsl:if test="$pocet &gt; 1">
        <!-- pro -->
        <xsl:call-template name="vykonprazdny">
          <xsl:with-param name="pocet" select="$pocet - 1"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:if>
  </xsl:template>


  <!-- odstrankuje kdyz počet radek naplnil 1 stranku
     a kdykoli pocet radek - prvni stranka je delitelny $radeknbezp-->
  <xsl:template name="testpage">
    <xsl:param name="pcr" select="1"/>
    <!-- odstrankovani na prvni strance -->
    <xsl:if test="$pcr = $radek1bezp">
      <xsl:call-template name="newpage">
        <xsl:with-param name="numpage" select="2"/>
        <xsl:with-param name="pcr" select="$pcr"/>
      </xsl:call-template>
    </xsl:if>
    <!-- pro dalsi stranky -->
    <xsl:if test="$pcr &gt; $radek1bezp">
      <xsl:if test="(($pcr - $radek1bezp) mod $radeknbezp) = 0">
        <xsl:call-template name="newpage">
          <xsl:with-param name="numpage" select="floor((($pcr - $radek1bezp) div $radeknbezp))+2"/>
          <xsl:with-param name="pcr" select="$pcr"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <!-- Odstránkování s nadpisem -->
  <xsl:template name="newpage">
    <xsl:param name="numpage" select="1"/>
    <xsl:param name="pcr" select="0"/>
    <!-- ukoncit stranku -->
    <DIV class="mainramtop"/>

    <!-- odstrankovat -->
    <DIV class="newpage">
      <PRE>
        <span class="podtr">
          evid.č:
          <xsl:value-of select="//CISF"/>
        </span>
        strana č.:
        <xsl:value-of select="$numpage"/>
        /
        <xsl:value-of select="$stran"/>
      </PRE>
    </DIV>
    <!-- nadpis tabulky pro novou stranku -->
    <BR/>
    <br/>
    <xsl:call-template name="telohead">
    </xsl:call-template>
  </xsl:template>

  <!-- Odstránkování bez nadpisu tabulky -->
  <xsl:template name="newpagepata">
    <xsl:param name="numpage" select="1"/>
    <!-- ukoncit stranku -->
    <DIV class="mainramtop"/>

    <!-- odstrankovat -->
    <DIV class="newpage">
      <PRE>
        <span class="podtr">
          evid.č:
          <xsl:value-of select="//CISF"/>
        </span>
        strana č.:
        <xsl:value-of select="$numpage"/>
        /
        <xsl:value-of select="$stran"/>
      </PRE>
    </DIV>
  </xsl:template>

</xsl:stylesheet>
