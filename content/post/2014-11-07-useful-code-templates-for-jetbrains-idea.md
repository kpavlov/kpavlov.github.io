---
title: "Useful Code Templates for Jetbrains Idea"
date: 2014-11-07T07:10:16
comments: true
categories:
  - programming
tags:
  - code style
  - idea
---

Jetbrains Idea is a perfect IDE (sorry, Eclipse fans).
But, like every tool, sometimes it needs some customization to fit your needs.
Today I want to show how to adjust it's code-generation templates.

When you generates a new class or method using Idea, it creates one using predefined templates.
You may modify that template in **"Settings -> File and Code templates"** section.

![Modifying file](/assets/2014/11/code-templates-for-idea-1.png)
<!--more-->

## Idea Configuration

Idea keeps it's configuration under `~/.IntelliJIdeaXX/config` folder.
I usualy copy my customized settings from in GIT repository, so, it is very easy to share, synchronize and restore it later.

```bash
$ ls -1F
codestyles/
colors/
componentVersions/
disabled_plugins.txt
disabled_update.txt
eval/
fileTemplates/
filetypes/
idea12.key
idea13.key
idea14.key
inspection/
jdbc-drivers/
keymaps/
options/
port
quicklists/
shelf/
tasks/
templates/
tools/
```

Code snippets (or code templates) are located inside `config/templates` folder.

## Code Snippets

### Implemented Method Body

Default method body template generates empty method or method returning default value.
I suggest throwing `UnsupportedOperationException` exception by default. It's more restrictive settings, but good for self-discipline.

Just create a file `config/fileTemplates/code/Implemented Method Body.java` with following contents:
``` java
throw new UnsupportedOperationException("Method is not implemented: ${CLASS_NAME}
```

### SLF4J Logger Declaration

If you're using SLF4j as logging framework, following code template will be very usefull.
Just press ``Cmd+J`` when cursor is in class declaration area and type `log`. Add to _config/templates/user.xml_).

```xml
<templateSet group="user">
  <template name="log" value="    private final org.slf4j.Logger logger = org.slf4j.LoggerFactory.getLogger($CLASS_NAME$.class);" description="SLF4j Logger Declaration"
 toReformat="true" toShortenFQNames="true" useStaticImport="true">
    <variable name="CLASS_NAME" expression="className()" defaultValue="" alwaysStopAt="true" />
    <context>
      <option name="JAVA_DECLARATION" value="true" />
    </context>
  </template>
</templateSet>
```
