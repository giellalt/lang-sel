# gt.m4 - Macros to locate and utilise giellatekno scripts -*- Autoconf -*-
# serial 1 (gtsvn-1)
# 
# Copyright © 2011 Divvun/Samediggi/UiT <bugs@divvun.no>.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 3 of the License.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
#
# As a special exception to the GNU General Public License, if you
# distribute this file as part of a program that contains a
# configuration script generated by Autoconf, you may include it under
# the same distribution terms that you use for the rest of that program.

# the prefixes gt_*, _gt_* are reserved here for giellatekno variables and
# macros. It is the same as gettext and probably others, but I expect no
# collisions really.


AC_DEFUN([gt_PROG_SCRIPTS_PATHS],
         [
AC_ARG_VAR([GTMAINTAINER], [define if you are maintaining the infra to get additional complaining about infra integrity])
AM_CONDITIONAL([WANT_MAINTAIN], [test x"$GTMAINTAINER" != x])
AC_PATH_PROG([GTVERSION], [gt-version.sh], [false],
             [$GTCORE/scripts/$PATH_SEPARATOR$GTHOME/gtcore/scripts/$PATH_SEPARATOR$PATH])
AC_PATH_PROG([GTCORESH], [gt-core.sh], [false],
             [$GTCORE/scripts/$PATH_SEPARATOR$GTHOME/gtcore/scripts/$PATH_SEPARATOR$PATH])

AC_MSG_CHECKING([whether GTCORE is found])
AS_IF([test "x$GTCORE"    = x -a \
            "x$GTCORESH" != xfalse ],
            [GTCORE=$(${GTCORESH}); AC_MSG_RESULT([yes - via script])],
	  [test "x$GTCORE" != x], [AC_MSG_RESULT([yes - via environment])],
      [AC_MSG_RESULT([no])])

AC_ARG_VAR([GTCORE], [directory for giellatekno core data])

AS_IF([test "x$GTCORE" = x], 
      [cat<<EOT

Could not set GTCORE and thus not find required scripts in:
       $GTCORE/scripts 
       $GTHOME/gtcore/scripts 
       $PATH 

       Please do the following: 
       1. svn co https://victorio.uit.no/langtech/trunk/gtcore
       2. then either:
         a: cd gtcore && ./autogen.sh && ./configure && make install
          or:
         b: add the following to your ~/.bash_profile or ~/.profile:

       export \$GTCORE=/path/to/gtcore/checkout/dir/

       (replace the path with the real path from 1. above)

EOT
       AC_MSG_ERROR([GTCORE could not be set])])
]) # gt_PROG_SCRIPTS_PATHS

AC_DEFUN([gt_PROG_XFST],
[AC_ARG_WITH([xfst],
            [AS_HELP_STRING([--with-xfst=DIRECTORY],
                            [search xfst in DIRECTORY @<:@default=PATH@:>@])],
            [with_xfst=$withval],
            [with_xfst=yes])
AC_PATH_PROG([PRINTF], [printf], [echo -n])
AC_PATH_PROG([XFST], [xfst], [false], [$PATH$PATH_SEPARATOR$with_xfst])
AC_PATH_PROG([TWOLC], [twolc], [false], [$PATH$PATH_SEPARATOR$with_xfst])
AC_PATH_PROG([LEXC], [lexc], [false], [$PATH$PATH_SEPARATOR$with_xfst])
AC_PATH_PROG([LOOKUP], [lookup], [false], [$PATH$PATH_SEPARATOR$with_xfst])
AC_MSG_CHECKING([whether we can enable xfst building])
AS_IF([test x$with_xfst != xno], [
    AS_IF([test "x$XFST" != xfalse], [gt_prog_xfst=yes],
          [gt_prog_xfst=no])
], [gt_prog_xfst=no])
AC_MSG_RESULT([gt_prog_xfst])
AM_CONDITIONAL([CAN_XFST], [test "x$gt_prog_xfst" != xno])
]) # gt_PROG_XFST

AC_DEFUN([gt_PROG_VISLCG3],
[AC_ARG_WITH([vislcg3],
            [AS_HELP_STRING([--with-vislcg3=DIRECTORY],
                            [search vislcg3 in DIRECTORY @<:@default=PATH@:>@])],
            [with_vislcg3=$withval],
            [with_vislcg3=check])
AC_PATH_PROG([VISLCG3_COMP], [cg-comp], [no], [$PATH$PATH_SEPARATOR$with_vislcg3])
AC_MSG_CHECKING([whether we can enable vislcg3 building])
AS_IF([test "x$VISLCG3" != xno], [AC_MSG_RESULT([yes])],
      [AC_MSG_RESULT([no])])
AS_IF([test "x$VISLCG3" != xno], [gt_prog_vislcg3=yes],
      [gt_prog_vislcg3=no])
AM_CONDITIONAL([CAN_VISLCG], [test "x$VISLCG3_COMP" != xno])
]) # gt_PROG_VISLCG3

AC_DEFUN([gt_PROG_SAXON],
[AC_ARG_WITH([saxon],
             [AS_HELP_STRING([--with-saxon=DIRECTORY],
                             [search saxon wrapper script in DIRECTORY @<:@default=PATH@:>@])],
             [with_saxon=$withval],
             [with_saxon=check])
AC_PATH_PROG([SAXON], [saxonb-xslt saxon9 saxon8 saxon], [false], [$PATH$PATH_SEPARATOR$with_saxon])
AC_PATH_PROG([JV], [java], [false])
AC_CHECK_FILE([/opt/local/share/java/saxon9he.jar],
    AC_SUBST(SAXONJAR, [/opt/local/share/java/saxon9he.jar]),
        [AC_CHECK_FILE([$HOME/lib/saxon9he.jar],
            AC_SUBST(SAXONJAR, [$HOME/lib/saxon9he.jar]),
                [AC_CHECK_FILE([$HOME/lib/saxon9.jar],
                    AC_SUBST(SAXONJAR, [$HOME/lib/saxon9.jar]),
                [saxonjar=no])
                ])]
)
AC_MSG_CHECKING([whether we can enable xslt2 transformations])
AS_IF([test x$with_saxon != xno], [
    AS_IF([test "x$SAXON" != xfalse], [gt_prog_saxon=yes],
          [gt_prog_saxon=no])
    AS_IF([test x$JV != xfalse], [gt_prog_java=yes], [gt_prog_java=no])
    AS_IF([test x$gt_prog_java != xno -a x$saxonjar != xno],
          [gt_prog_xslt=yes], [gt_prog_xslt=no])
], [gt_prog_xslt=no])
AC_MSG_RESULT([$gt_prog_xslt])
AM_CONDITIONAL([CAN_SAXON], [test "x$gt_prog_saxon" != xno])
AM_CONDITIONAL([CAN_JAVA], [test "x$gt_prog_java" != xno -a "x$saxonjar" != xno]) 
]) # gt_PROG_SAXON

AC_DEFUN([gt_ENABLE_TARGETS],
[
# Enable morphological analysers - default is 'yes'
AC_ARG_ENABLE([morphology],
              [AS_HELP_STRING([--enable-morphology],
                              [build morphological analysers @<:@default=yes@:>@])],
              [enable_morphology=$enableval],
              [enable_morphology=yes])
AM_CONDITIONAL([WANT_MORPHOLOGY], [test "x$enable_morphology" != xno])

# Enable morphological generators - default is 'yes'
AC_ARG_ENABLE([generation],
              [AS_HELP_STRING([--enable-generation],
                              [build morphological generators @<:@default=yes@:>@])],
              [enable_generation=$enableval],
              [enable_generation=yes])
AM_CONDITIONAL([WANT_GENERATION], [test "x$enable_generation" != xno])

# Enable all spellers - default is 'no'
AC_ARG_ENABLE([spellers],
              [AS_HELP_STRING([--enable-spellers],
                              [build any/all spellers @<:@default=no@:>@])],
              [enable_spellers=$enableval],
              [enable_spellers=no])
AM_CONDITIONAL([WANT_SPELLERS], [test "x$enable_spellers" != xno])

# Enable hfst speller transducers - default is 'no'
AC_ARG_ENABLE([spellerautomat],
              [AS_HELP_STRING([--enable-spellerautomat],
                              [build speller hfst (dependent on --enable-spellers) @<:@default=yes@:>@])],
              [enable_spellerautomat=$enableval],
              [enable_spellerautomat=yes])
AS_IF([test "x$enable_spellers" = xno], [enable_spellerautomat=no])
AM_CONDITIONAL([WANT_SPELLERAUTOMAT], [test "x$enable_spellerautomat" != xno])

# Enable voikko - default is 'yes', but only if the speller automate is enabled
AC_ARG_ENABLE([voikko],
              [AS_HELP_STRING([--enable-voikko],
                              [build voikko speller (dependent on --enable-spellers) @<:@default=yes@:>@])],
              [enable_voikko=$enableval],
              [enable_voikko=yes])
AS_IF([test "x$enable_spellerautomat" = xno], [enable_voikko=no])
AM_CONDITIONAL([WANT_VOIKKO], [test "x$enable_voikko" != xno ])

# Foma-speller requires gzip, Voikko requires zip:
AC_PATH_PROG([ZIP],  [zip],  [false], [$PATH$PATH_SEPARATOR$with_zip])
AC_PATH_PROG([GZIP], [gzip], [false], [$PATH$PATH_SEPARATOR$with_gzip])

# Enable Foma-based spellers, requires gzip - default is no
AC_ARG_ENABLE([fomaspeller],
              [AS_HELP_STRING([--enable-fomaspeller],
                              [build foma speller (dependent on --enable-spellers) @<:@default=no@:>@])],
              [enable_fomaspeller=$enableval],
              [enable_fomaspeller=no])
AS_IF([test "x$enable_fomaspeller" = "xyes" -a "x$gt_prog_hfst" != xno], 
      [AS_IF([test "x$GZIP" = "xfalse"],
             [enable_fomaspeller=no
              AC_MSG_WARN([gzip missing, foma spellers disabled])])])
AM_CONDITIONAL([CAN_FOMA_SPELLER], [test "x$enable_fomaspeller" != xno])

# Enable Hunspell production - default is 'no'
AC_ARG_ENABLE([hunspell],
              [AS_HELP_STRING([--enable-hunspell],
                              [enable hunspell building @<:@default=no@:>@])],
              [enable_hunspell=$enableval],
              [enable_hunspell=no])
AM_CONDITIONAL([WANT_HUNSPELL], [test "x$enable_hunspell" != xno])

# Enable grammar checkers - default is 'no'
AC_ARG_ENABLE([grammarchecker],
              [AS_HELP_STRING([--enable-grammarchecker],
                              [enable grammar checker @<:@default=no@:>@])],
              [enable_grammarchecker=$enableval],
              [enable_grammarchecker=no])
AS_IF([test "x$enable_grammarchecker" = "xyes" -a "x$VISLCG3_COMP" = "x"], 
      [enable_grammarchecker=no
       AC_MSG_WARN([vislcg3 missing, grammar checker disabled])])
AM_CONDITIONAL([WANT_GRAMCHECK], [test "x$enable_grammarchecker" != xno])

# Enable dictionary transducers - default is 'no'
AC_ARG_ENABLE([dicts],
              [AS_HELP_STRING([--enable-dicts],
                              [enable dictionary transducers @<:@default=no@:>@])],
              [enable_dicts=$enableval],
              [enable_dicts=no])
AM_CONDITIONAL([WANT_DICTIONARIES], [test "x$enable_dicts" != xno])

AS_IF([test "x$enable_voikko" = "xyes" -a "x$gt_prog_hfst" != xno], 
      [AS_IF([test "x$ZIP" = "xfalse"],
             [enable_voikko=no
              AC_MSG_WARN([zip missing, voikko spellers disabled])])])

# Enable Oahpa transducers - default is 'no'
AC_ARG_ENABLE([oahpa],
              [AS_HELP_STRING([--enable-oahpa],
                              [enable oahpa transducers @<:@default=no@:>@])],
              [enable_oahpa=$enableval],
              [enable_oahpa=no])
AM_CONDITIONAL([WANT_OAHPA], [test "x$enable_oahpa" != xno])

# Enable IPA conversion - default is 'no'
AC_ARG_ENABLE([phonetic],
              [AS_HELP_STRING([--enable-phonetic],
                              [enable phonetic transducers @<:@default=no@:>@])],
              [enable_phonetic=$enableval],
              [enable_phonetic=no])
AM_CONDITIONAL([WANT_PHONETIC], [test "x$enable_phonetic" != xno])

# Enable Apertium transducers - default is 'no'
AC_ARG_ENABLE([apertium],
              [AS_HELP_STRING([--enable-apertium],
                              [enable apertium transducers @<:@default=no@:>@])],
              [enable_apertium=$enableval],
              [enable_apertium=no])
AM_CONDITIONAL([WANT_APERTIUM], [test "x$enable_apertium" != xno])

]) # gt_ENABLE_TARGETS

AC_DEFUN([gt_PRINT_FOOTER],
[
cat<<EOF

-- Building $PACKAGE_STRING:

  -- basic package (on by default except hfst): --
  * build with Xerox: $gt_prog_xfst
  * build with HFST: $gt_prog_hfst
  * analysers enabled: $enable_morphology
  * generators enabled: $enable_generation
  * syntactic processing enabled: $gt_prog_vislcg3
  * yaml tests enabled: $enable_yamltests
  * generated documentation enabled: $gt_prog_docc

  -- proofing tools (off by default): --
  * spellers enabled: $enable_spellers
    * hfst speller fst's enabled: $enable_spellerautomat
    * voikko speller enabled: $enable_voikko
    * foma speller enabled: $enable_fomaspeller
  * grammar checker enabled: $enable_grammarchecker

  -- specialised fst's (off by default): --
  * phonetic/IPA conversion enabled: $enable_phonetic
  * dictionary fst's enabled: $enable_dicts
  * Oahpa transducers enabled: $enable_oahpa
  * Apertium transducers enabled: $enable_apertium

For more ./configure options, run ./configure --help

To build, test and install:
    make
    make check
    make install
EOF
AS_IF([test x$gt_prog_xfst = xno -a x$gt_prog_hfst = xno],
      [AC_MSG_WARN([Both XFST and HFST are disabled: no automata will be built])])
AS_IF([test x$gt_prog_xslt = xno -a \
      "$(find ./src/morphology/stems -name "*.xml" | head -n 1)" != "" ],
      [AC_MSG_WARN([You have XML source files, but XML transformation to LexC is
disabled. Please check the output of configure to locate any problems.
])])
AS_IF([test x$gt_prog_docc = xno],
      [AC_MSG_WARN([Could not find gawk, java or forrest. In-source documentation will not be extracted and validated. Please install the required tools.])])
]) # gt_PRINT_FOOTER
# vim: set ft=config: 