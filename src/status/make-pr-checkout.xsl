<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:g='http://nwalsh.com/ns/git-repo-info'
                xmlns='http://nwalsh.com/ns/git-repo-info'
                exclude-result-prefixes="xs"
                expand-text="yes"
                version="3.0">

<xsl:output method="text" encoding="utf-8" indent="yes"/>

<xsl:param name="archive-path" select="'/tmp/y'"/>

<xsl:mode on-no-match="shallow-skip"/>

<xsl:template match="/">
  <xsl:text>#!/bin/bash&#10;</xsl:text>
  <xsl:text>&#10;</xsl:text>
  <xsl:text>git checkout gh-pages&#10;</xsl:text>
  <xsl:text>OPENPRS=()&#10;</xsl:text>
  <xsl:text>cd pr&#10;</xsl:text>
  <xsl:text>for f in [0-9]*; do &#10;</xsl:text>
  <xsl:text>    OPENPRS+=($f)&#10;</xsl:text>
  <xsl:text>done&#10;</xsl:text>
  <xsl:text>cd ..&#10;</xsl:text>
  <xsl:text>&#10;</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>git checkout gh-pages&#10;</xsl:text>
</xsl:template>

<xsl:template match="g:pr-commit">
  <xsl:text>git checkout {string(g:hash)}&#10;</xsl:text>
  <xsl:text>git checkout HEAD~1&#10;</xsl:text>
  <xsl:for-each select="g:pr">
    <xsl:text>if [[ " ${{OPENPRS[*]}} " =~ " {string(.)} " ]]; then&#10;</xsl:text>
    <xsl:text>  echo "Skipping open PR {string(.)}"&#10;</xsl:text>
    <xsl:text>else&#10;</xsl:text>
    <xsl:text>  echo "Archiving PR {string(.)}"&#10;</xsl:text>
    <xsl:text>  zip -rpq {$archive-path}/{string(.)} pr/{string(.)}&#10;</xsl:text>
    <xsl:text>fi&#10;</xsl:text>
  </xsl:for-each>
  <xsl:text>&#10;</xsl:text>
</xsl:template>

</xsl:stylesheet>
