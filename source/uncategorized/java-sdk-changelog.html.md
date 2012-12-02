---
title: Java-sdk-changelog
authors: michael pasternak
wiki_title: Java-sdk-changelog
wiki_revision_count: 32
wiki_last_updated: 2013-12-25
wiki_conversion_fallback: true
wiki_warnings: conversion-fallback
---

# Java-sdk-changelog

        commit 2aa927a0b57817bb0e7f3ef7b5213bf143c81832
        Author: Michael Pasternak 
        Date:   Sat Dec 1 11:49:26 2012 +0200

            codegen: modify docs to explain relation between entities

            Change-Id: I7ca8f243887cd2824a9ebd314ae2138403696f78
            Signed-off-by: Michael Pasternak 

        commit 7afe814ea4c1963c2b76d67b23cec27126bd350b
        Author: Michael Pasternak 
        Date:   Thu Nov 29 14:09:52 2012 +0200

            codegen: link decorators docs to the parent types

            Change-Id: I54e0a5342e60b2a62ee298e2b0aad883c62cebad
            Signed-off-by: Michael Pasternak 

        commit da1347a5eecab93d007bd120bfedab5f5cf7d2e9
        Author: Michael Pasternak 
        Date:   Thu Nov 29 12:56:04 2012 +0200

            sdk: modify compare for the same type

            Change-Id: I5264de346fc0bc7355ce753875000c0131e6954c
            Signed-off-by: Michael Pasternak 

        commit 0c1a74f4dd8d823b2d98be0ea53c0ba253a63180
        Author: Michael Pasternak 
        Date:   Thu Nov 29 12:48:11 2012 +0200

            sdk: do not unmarshall opjects of same type

            Change-Id: I08bd1ab839193f510d0b96e136577855fead2381
            Signed-off-by: Michael Pasternak 

        commit 291d70d539f13214feb61cc2cc5272556d0800f0
        Author: Michael Pasternak 
        Date:   Thu Nov 29 12:04:20 2012 +0200

            codegen: show link to returned object in documentation

            Change-Id: I3c007eeb1573e464231fb4e95a1004da91f2dbb8
            Signed-off-by: Michael Pasternak 

        commit 15fd13f1d98ff0ed0c79ebbd702871ce632313ff
        Author: Michael Pasternak 
        Date:   Wed Nov 28 15:31:28 2012 +0200

            codegen: cleanup

            Change-Id: I2c7e6354ac127b3e93d275c6a8eefa5e76b2c8fb
            Signed-off-by: Michael Pasternak 

        commit a633a03c5529a188e87e4239770f0e59d97d72d5
        Author: Michael Pasternak 
        Date:   Wed Nov 28 10:34:04 2012 +0200

            codegen: do not deligate JAXBException

            Change-Id: I1e9d19a212c2ca623d50814d8562c4f90f933166
            Signed-off-by: Michael Pasternak 

        commit 12423f271d17482d43b425add990b02b28879abd
        Author: Michael Pasternak 
        Date:   Tue Nov 27 18:58:09 2012 +0200

            sdk: remove Example file

            Change-Id: Ida5c5dc7dfb75a133e790a48f00e9c94d0b7ea1a
            Signed-off-by: Michael Pasternak 

        commit 8f8c85693122467d609421f779343b337a608449
        Author: Michael Pasternak 
        Date:   Tue Nov 27 18:57:04 2012 +0200

            codegen: refactor DocsCodegen to display  snippets

            Change-Id: I76f91f12d9006555cdcde198ad7fdedb2ae70f64
            Signed-off-by: Michael Pasternak 

        commit c499d88b14066d9867bab00fc20a3cf5f1e49e22
        Author: Michael Pasternak 
        Date:   Tue Nov 27 18:55:26 2012 +0200

            sdk: refactor Mapper

            Change-Id: I7a83e1798f8d7a13ef22324731c81a275c3dcf1e
            Signed-off-by: Michael Pasternak 

        commit 9a6bf32e9ff68a3ef0438badb8ef8d9c5750fafe
        Author: Michael Pasternak 
        Date:   Tue Nov 27 16:55:59 2012 +0200

            codegen: differentiate between optional and mandatory params in doc

            Change-Id: I71e3556c05f5ca8dfce18467f802f830f68d07f9
            Signed-off-by: Michael Pasternak 

        commit 9699b491932a8470ceea90d1e452ece6443513b9
        Author: Michael Pasternak 
        Date:   Tue Nov 27 15:23:27 2012 +0200

            codegen: implement detailed documentation

            Change-Id: Ib97e524be1aa0183e8e60a31b71054c701f8cf9f
            Signed-off-by: Michael Pasternak 

        commit b80d6baeee29d7c2bba4a7c34d8ac41936d5a0ed
        Author: Michael Pasternak 
        Date:   Tue Nov 27 12:21:42 2012 +0200

            codegen: implement generic documentation

            Change-Id: I5d0f2d83fc51bcea92c6555ea99192a2e3c8abe0
            Signed-off-by: Michael Pasternak 

        commit dc2c77dc095675b7ebdc43567c7c4e2e4efba4d6
        Author: Michael Pasternak 
        Date:   Mon Nov 26 22:11:06 2012 +0200

            codegen: modify getters of api entities

            Modifies public getters to return Object so inheriting
            classes could override them with different signature

            Change-Id: I15759c95bb273c79705b5906ef90ed7314c0d1c8
            Signed-off-by: Michael Pasternak 

        commit f84833d90d33ba20a05f4fe791781ed5776bd8fb
        Author: Michael Pasternak 
        Date:   Mon Nov 26 20:28:50 2012 +0200

            codegen: inject Copyright header to api entities

            Change-Id: Id12b9213b5cb87e632433bcdd4103ace01a9fa20
            Signed-off-by: Michael Pasternak 

        commit f60b365242dbda50117bd47e5f5bea110d289e20
        Author: Michael Pasternak 
        Date:   Mon Nov 26 15:46:19 2012 +0200

            codegen: add "generated code" header

            Change-Id: I9768e09e1de70465cc4fdfec743321fe048add79
            Signed-off-by: Michael Pasternak 

        commit b2fcbff09902e78810722fbee32beca3b380d153
        Author: Michael Pasternak 
        Date:   Mon Nov 26 15:12:12 2012 +0200

            codegen: remove shadowed accessors from api entities

            remove of shadowed accessors from api entities is needed cause inheriting
            decorators reusing them, but returning different types

            Change-Id: I9a740b65fe1791e63056835e5b362f8d6fd20a14
            Signed-off-by: Michael Pasternak 

        commit 83403e03376fd20005497d9351aefadc7b5b77c3
        Author: Michael Pasternak 
        Date:   Sun Nov 25 18:25:17 2012 +0200

            codegen: simplify collection getter names

            Change-Id: Icc627b5a50016821cbc070bebf77fbe2ea8671d4
            Signed-off-by: Michael Pasternak 

        commit 6e606cc8d0c94006771c817461870f33cb4080de
        Author: Michael Pasternak 
        Date:   Sun Nov 25 15:46:18 2012 +0200

            codegen: remove trailing new lines

            Change-Id: I69b6237428496678a38fbe16e23fed8756c9aad0
            Signed-off-by: Michael Pasternak 

        commit 7ac212317aeef8fa2c0a0adfa33852bd475a0aa0
        Author: Michael Pasternak 
        Date:   Sun Nov 25 15:06:35 2012 +0200

            codegen: cleanup

            Change-Id: I10fa4f99bf8b10501e300c781d73e46f64f23ca4
            Signed-off-by: Michael Pasternak 

        commit b3cde212a80786e5efbdcc0fd4b076a0bd9dc439
        Author: Michael Pasternak 
        Date:   Sun Nov 25 14:33:56 2012 +0200

            codegen: implement /add method codegen

            Change-Id: I1f154a57b5fb3b83a865c46263bd1bde40c7569c
            Signed-off-by: Michael Pasternak 

        commit 56adf19fe1f2b63c50567b54a8d083f624d1b9c7
        Author: Michael Pasternak 
        Date:   Sun Nov 25 13:31:19 2012 +0200

            codegen: implement /update method codegen

            Change-Id: I65aa6a75bad9c8e3a8b30b5fe71b386115d60f6c
            Signed-off-by: Michael Pasternak 

        commit ec9820ea4a927b39ae8ecbf187b94ea08f3ba807
        Author: Michael Pasternak 
        Date:   Sun Nov 25 13:06:09 2012 +0200

            codegen: implement /delete method codegen

            Change-Id: Iccf449c9d911cac58f9b18b5f2d01b75a79d4edf
            Signed-off-by: Michael Pasternak 

        commit 44d6b00aad8af3e84eaabb4efb309d6e430bbe3c
        Author: Michael Pasternak 
        Date:   Sun Nov 25 11:56:59 2012 +0200

            codegen: wrap actions that using java preserved words

            Change-Id: I5fd31471eaa6efe376281b9514e0c1618da249e5
            Signed-off-by: Michael Pasternak 

        commit 72e1cd75c8bc247e329890b4fbd4755afe2341fb
        Author: Michael Pasternak 
        Date:   Sun Nov 25 11:24:58 2012 +0200

            codegen: add Action import to SubCollection template

            Change-Id: I775b47d35d33a91dce2edd102360b4b12eb7479d
            Signed-off-by: Michael Pasternak 

        commit b7dc29f264efbd98764246606eb7b7c1f924bbd2
        Author: Michael Pasternak 
        Date:   Sun Nov 25 11:23:21 2012 +0200

            codegen: implelement collection actions codegen

            Change-Id: I1ca4798f3e5e757f25a31bb2254f4a1d89966671
            Signed-off-by: Michael Pasternak 

        commit 4d8d41439bb844ec126709fa6b4e79e5053ae780
        Author: Michael Pasternak 
        Date:   Sun Nov 25 10:57:53 2012 +0200

            codegen: implelement resource actions codegen

            Change-Id: I3f614d663f458efa983b899deda98684203be17f
            Signed-off-by: Michael Pasternak 

        commit 353abdaac588fb7ca69c278a446e9bea806153eb
        Author: Michael Pasternak 
        Date:   Thu Nov 22 15:57:48 2012 +0200

            codegen: implement support for any depth URL

            Change-Id: Ia7b958bc04c246726c035f01fd63edb6e3939293
            Signed-off-by: Michael Pasternak 

        commit d130a165cacfcdf192090c00938b065eafdf48b2
        Author: Michael Pasternak 
        Date:   Thu Nov 22 14:35:55 2012 +0200

            codegen: remove whitespaces at injection points

            Change-Id: I6e3f4831ba3af02a8c261847e7f3cc0dbdad244d
            Signed-off-by: Michael Pasternak 

        commit 13e1b631fbd65084b28fb5b19c31dbd75887581c
        Author: Michael Pasternak 
        Date:   Thu Nov 22 14:32:59 2012 +0200

            codegen: fix incorrect sub-collection url name detection

            Change-Id: I92ce9fee9cc2db7291185ff97cf1b9a53e5551f7
            Signed-off-by: Michael Pasternak 

        commit 9292212e793972690d579d15ff880ff92db32755
        Author: Michael Pasternak 
        Date:   Thu Nov 22 14:06:20 2012 +0200

            codegen: fix public entity name for exceptional server entities

            Change-Id: I5853c530ecbc09e87ca257e29dfbbbd90a458189
            Signed-off-by: Michael Pasternak 

        commit feffbbe1690b154f0d15a27b8144b390d9b53e34
        Author: Michael Pasternak 
        Date:   Thu Nov 22 13:07:56 2012 +0200

            codegen: implement SDK entry point ApiCodegen

            Change-Id: Ib544c2916c9d0a9684bf1f043f96b8d749df1390
            Signed-off-by: Michael Pasternak 

        commit 309570dc0ea85d9ab8a5f019b7226cb01a2b6062
        Author: Michael Pasternak 
        Date:   Thu Nov 22 11:13:04 2012 +0200

            sdk: implement generic get-by-name method in CollectionDecorator

            Change-Id: Ie63a594d0f98716680bedd840688d33f03c5cee6
            Signed-off-by: Michael Pasternak 

        commit c1a30b9e1a351d285594586bc594b8e1b3f83f5d
        Author: Michael Pasternak 
        Date:   Wed Nov 21 18:29:39 2012 +0200

            codegen: cleanup

            Change-Id: I1205ace97c49034000a4edeca3eccc315778b1a8
            Signed-off-by: Michael Pasternak 

        commit de83269c80d2ad1ec4172734c9798aab44490792
        Author: Michael Pasternak 
        Date:   Wed Nov 21 18:29:04 2012 +0200

            codegen: use StringBuffer instead of String

            Change-Id: If84f8f51b6e11857d67a0767fec0a4facd0d6d45
            Signed-off-by: Michael Pasternak 

        commit c09c5092e6a9712ce1ec950d6add799951aa622c
        Author: Michael Pasternak 
        Date:   Wed Nov 21 18:26:58 2012 +0200

            codegen: use SLASH constraint in URLs

            Change-Id: Ic1185c597e991bbc34d19102e158113fd9c7733b
            Signed-off-by: Michael Pasternak 

        commit c7910412fa015da1555fa3eacc4050b407f6c9d0
        Author: Michael Pasternak 
        Date:   Wed Nov 21 16:34:36 2012 +0200

            codegen: implement releations between resources and sub-collections

            Change-Id: I945d1599d624a8c765a081b0899862f56505c1d4
            Signed-off-by: Michael Pasternak 

        commit ec7caab76864535d33ab5d6d1e34576c47de0c0e
        Author: Michael Pasternak 
        Date:   Wed Nov 21 14:40:10 2012 +0200

            codegen: move collection name to super and reuse it

            Change-Id: I690cc4a5d111214ae77d2f67c4b5cae165b16f99
            Signed-off-by: Michael Pasternak 

        commit 05dd8fae3a357bfc420eef67096c10101e98dbdd
        Author: Michael Pasternak 
        Date:   Wed Nov 21 13:54:37 2012 +0200

            codegen: implement list/get methods gen for collections

            Change-Id: I6afb9745c0563e9f91acfdf3f3ee585007efbe94
            Signed-off-by: Michael Pasternak 

        commit 6c9cf376e36a0cf08119fa8a8b4f2e744312159c
        Author: Michael Pasternak 
        Date:   Wed Nov 21 12:01:24 2012 +0200

            codegen: fetch template name dynamically

            Change-Id: I5c85f53e2b1f057d9b73b4fed19167ae2d095dcc
            Signed-off-by: Michael Pasternak 

        commit 38b21bcd3e406c6a7f778b27f6894e453935cccc
        Author: Michael Pasternak 
        Date:   Tue Nov 20 16:35:37 2012 +0200

            codegen: implement RsdlCodegen

            Change-Id: Ic18b9d5077fa3e960ecba30ad216af7de8d1ceb5
            Signed-off-by: Michael Pasternak 

        commit 7204f29a1080fc0f7072ae09750476f0a0b66000
        Author: Michael Pasternak 
        Date:   Sat Nov 17 00:05:39 2012 +0200

            sdk: implement new one-way warping get() signature

            Change-Id: Ic656007b3c6e756780d3e1f756540d03d915b616
            Signed-off-by: Michael Pasternak 

        commit 25d4584ede77b671603d8fb9d1eaa3222713df1e
        Author: Michael Pasternak 
        Date:   Sat Nov 17 00:05:03 2012 +0200

            sdk: implement StringUtils.toUpper()

            Change-Id: Ic492fcd5d6343bb5dfdc5e402a6ad91e46bb0f5e
            Signed-off-by: Michael Pasternak 

        commit c524c18069a7cb325cbcaa9a82eb2d2fe5dbda5c
        Author: Michael Pasternak 
        Date:   Sat Nov 17 00:03:10 2012 +0200

            codegen: implement decorators holders

            Change-Id: I000f21eb97266bf7c481252861578438967e9964
            Signed-off-by: Michael Pasternak 

        commit a6b856f96321ccace52446a73ecbfa248e65c3bb
        Author: Michael Pasternak 
        Date:   Wed Nov 14 14:03:18 2012 +0200

            codegen: rename Copyright file

            Change-Id: I48d1a809f315de8132ca623c2bd059b1864ea22a
            Signed-off-by: Michael Pasternak 

        commit e214b3c978b0b4ca68f4f10aae70f27de4a7ca5d
        Author: Michael Pasternak 
        Date:   Wed Nov 14 14:01:19 2012 +0200

            codegen: documentation + cleanup

            Change-Id: Icf212171f74aa50604ec75f7a11ac662a068f1c8
            Signed-off-by: Michael Pasternak 

        commit 256a3a8602ea520bb65317453a98ce0df6a6c74b
        Author: Michael Pasternak 
        Date:   Wed Nov 14 13:46:09 2012 +0200

            codegen: implement SubResource template

            Change-Id: I1442b972666a6f04097eb15ebb4a62adffd77c30
            Signed-off-by: Michael Pasternak 

        commit eff3a8fe31abbe21af866a1703f72ca2a379550c
        Author: Michael Pasternak 
        Date:   Wed Nov 14 12:59:03 2012 +0200

            codegen: implement SubCollection template

            Change-Id: Ida4b8bd0b348db5aa25bc6f3bd86e4270b56f3ac
            Signed-off-by: Michael Pasternak 

        commit e854c1db75c9c450863b9e02e56d9105403530c1
        Author: Michael Pasternak 
        Date:   Wed Nov 14 12:36:03 2012 +0200

            codegen: refacor CollectionTemmplate

            Change-Id: I096baf91fc9dda74d64ff3f0810ff3d27727fd3a
            Signed-off-by: Michael Pasternak 

        commit 5744fc336ab0506bad7e36695ba265e21549735e
        Author: Michael Pasternak 
        Date:   Wed Nov 14 12:31:22 2012 +0200

            codegen: implement Resource template

            Change-Id: I78291bab4fb4763302b6b2f6e7790014a41985d8
            Signed-off-by: Michael Pasternak 

        commit c307949233a125e3efd0e99ff3c5e5497eccbfff
        Author: Michael Pasternak 
        Date:   Wed Nov 14 12:20:37 2012 +0200

            codegen: rebase to HttpProxyBroker

            Change-Id: Ie48bf276d54fdce3299b22b90f138cbc54bdb398
            Signed-off-by: Michael Pasternak 

        commit c2d256353457342b1b316dc92a3cc464f07e1137
        Author: Michael Pasternak 
        Date:   Wed Nov 14 12:17:44 2012 +0200

            codegen: implement Copyright, Collection templates

            Change-Id: I7efdf3cf2157113104afc53496a78e5ad4fe84ca
            Signed-off-by: Michael Pasternak 

        commit b0bf9be566b505d9fb4e2860eea4d8f0a1e3a02f
        Author: Michael Pasternak 
        Date:   Wed Nov 14 11:10:15 2012 +0200

            sdk: added VmNic/VmNics decorators that will serve as codegen templates

            Change-Id: I89090a3136812b6134d0b81754568a69522b8272
            Signed-off-by: Michael Pasternak 

        commit bf63b12e3b2c175f0dbaac6cf2e933b67b76041b
        Author: Michael Pasternak 
        Date:   Tue Nov 13 17:27:48 2012 +0200

            sdk: add sub-collection decorator method overloads using constraints

            Change-Id: I8099a2d96df9649bc2d40afe00ccdcfec18ad81a
            Signed-off-by: Michael Pasternak 

        commit 9e73993c35ce9533f5e5230ce6384c0a7ad86279
        Author: Michael Pasternak 
        Date:   Tue Nov 13 17:12:17 2012 +0200

            sdk: add decorator collection method overloads using constraints

            Change-Id: I341c92715b8d33bd55481b96d9d818c5aa755873
            Signed-off-by: Michael Pasternak 

        commit 5ad22bb46b42c5dfbc5f2603c07ef60e9ac05e99
        Author: Michael Pasternak 
        Date:   Tue Nov 13 14:58:37 2012 +0200

            sdk: add decorator resource method overload using http header/s

            Change-Id: I10a9030cb473745c09f7302f17ae084c4573dd49
            Signed-off-by: Michael Pasternak 

        commit deb850c60c8c962ba4c65428f3e5ebf0e1f5cf2a
        Author: Michael Pasternak 
        Date:   Tue Nov 13 12:32:11 2012 +0200

            sdk: store entier parent class in child

            Change-Id: I5abfef9131c30dc61636dcb3c7922c925197ce05
            Signed-off-by: Michael Pasternak 

        commit 40d211b32165b05392bea99971163bdeb2e4f722
        Author: Michael Pasternak 
        Date:   Tue Nov 13 12:10:00 2012 +0200

            sdk: encapsulate HttpProxy

            Change-Id: I7548bd0830186b302202802f336646f544349902
            Signed-off-by: Michael Pasternak 

        commit 7a7cf83c81c70a198f97c6e74509cb9d5bbe8909
        Author: Michael Pasternak 
        Date:   Tue Nov 13 10:11:51 2012 +0200

            codegen: move xsd related code to own utility

            Change-Id: Ibbe26904f516f268bbb33f2b580233e69b040788
            Signed-off-by: Michael Pasternak 

        commit 6fb7f759aedf9bdf941f00c4cab35af71b1ee19a
        Author: Michael Pasternak 
        Date:   Tue Nov 13 09:48:36 2012 +0200

            sdk: add downloaded xsd schema to .gitignore

            Change-Id: Id8298cc8ca23f1e927d352f50a10cf55b5cac2bd
            Signed-off-by: Michael Pasternak 

        commit 67c6ca3a50d8730eabe6f837a1b7ab869c9f7841
        Author: Michael Pasternak 
        Date:   Tue Nov 13 09:45:42 2012 +0200

            codegen: remove jaxb header from jenerated entities classes

            Change-Id: Id133daf20c31d1641c449e7232bcd5d0c5e4f981
            Signed-off-by: Michael Pasternak 

        commit 90a91ce28466e597b0ed522b6f58655bf4ad98c6
        Author: Michael Pasternak 
        Date:   Mon Nov 12 19:43:43 2012 +0200

            sdk: cleanup

            Change-Id: I09919cff5b49e84b6ee572e49f2e3eeec1c768ae
            Signed-off-by: Michael Pasternak 

        commit 95a25a40216299bc17143020d31b8a0fc9441a89
        Author: Michael Pasternak 
        Date:   Mon Nov 12 19:42:49 2012 +0200

            codegen: implement entities generation form the api schema

            Change-Id: I21370c8f4a903d2d2ea99857aa89a512114d3c27
            Signed-off-by: Michael Pasternak 

        commit dbf6ba08852d76f05b79ef991aa1743f47df45db
        Author: Michael Pasternak 
        Date:   Sun Nov 11 18:05:55 2012 +0200

            sdk: implement VmStatistics sub-collection

            Change-Id: I083041ff77c99ca4662abc4bc60c6b5605e49d66
            Signed-off-by: Michael Pasternak 

        commit f7398cb5a4609dceaf4c1308b6d74d2c1858aa80
        Author: Michael Pasternak 
        Date:   Sun Nov 11 17:37:04 2012 +0200

            sdk: optimize SerializationHelper by reusing JAXBContext

            Change-Id: If07c33643b3e6f28b7980c0342bf29bf01945565
            Signed-off-by: Michael Pasternak 

        commit 87f100caba6ea3493767ca117da72d2f8ff02d2a
        Author: Michael Pasternak 
        Date:   Sun Nov 11 15:40:34 2012 +0200

            sdk: added generated entities classes

            Change-Id: I3b81ddef7a60f99afbd5481b7f27d1d34cd7928f
            Signed-off-by: Michael Pasternak 

        commit d40b7eccd69059e029cf78baf7917ce518c2dcbe
        Author: Michael Pasternak 
        Date:   Sun Nov 11 15:08:42 2012 +0200

            sdk: cleanup

            Change-Id: I9f84e88f710a1056cd7cc1d442c1b3d72debcffa

        commit 7cb92f5263bbb7bae1b2fce6093d78de863e9626
        Author: Michael Pasternak 
        Date:   Sun Nov 11 14:55:28 2012 +0200

            sdk: split java-sdk and java-sdk-codegen projects

            Change-Id: I4793e17e608f57ef821a72385c3e678be38a3ce1
            Signed-off-by: Michael Pasternak 

        commit de67ed66bc6b40f48e1641081dbb712917e7a8d4
        Author: Michael Pasternak 
        Date:   Sun Nov 11 14:38:54 2012 +0200

            sdk: implement generic mapping infrastructure

            Change-Id: I8b571fdfbc5a6a2fc6e71a02dfd385ffa2ea60d0
            Signed-off-by: Michael Pasternak 

        commit 03651f944b3269f375c9f3ff2c8ffdac17d6073f
        Author: Michael Pasternak 
        Date:   Sat Nov 10 16:13:30 2012 +0200

            sdk: fix vm resource methods return types

            Change-Id: I34e863211a00d9f1256fe1766bfd93f2b0cbc844
            Signed-off-by: Michael Pasternak 

        commit 9d91bb576188c8013bebacc62b1938c746386015
        Author: Michael Pasternak 
        Date:   Sat Nov 10 15:22:45 2012 +0200

            sdk: make resource name lowercase when serialazing to xml

            Change-Id: I1b41a5011a2dcbdd4af183a3586a5698b59f51fc
            Signed-off-by: Michael Pasternak 

        commit 130658b74945995b71a0be5f889835d9547f1d32
        Author: Michael Pasternak 
        Date:   Sat Nov 10 14:57:54 2012 +0200

            sdk: expose public HttpProxy setters in SDK proxy

            Change-Id: If55ecb12e74b926efa747436a2e0062dc24120fa
            Signed-off-by: Michael Pasternak 

        commit 9d2e2fc5e12670bca17138a9b745c67ed89ac8bd
        Author: Michael Pasternak 
        Date:   Sat Nov 10 14:50:43 2012 +0200

            sdk: fetch root resource in Api rather than in HttpProxy

            Change-Id: Idaf771314588209d56bfa6ba91a7a50c4706f71e
            Signed-off-by: Michael Pasternak 

        commit 4d2c9f847a750a4f2364e1ee754f25f8bdd2d074
        Author: Michael Pasternak 
        Date:   Sat Nov 10 14:03:23 2012 +0200

            sdk: add documentation

            Change-Id: I1da495808d184f9763776eaf0c654333915421ce
            Signed-off-by: Michael Pasternak 

        commit 068044f044275ca575c50847f98e5ea58987f13f
        Author: Michael Pasternak 
        Date:   Sat Nov 10 13:01:31 2012 +0200

            sdk: remove .classpath from git

            Change-Id: I681e256d8d45e59c92cc5bc4c733cc774fb5b281
            Signed-off-by: Michael Pasternak 

        commit 197e8360f15467f4578059d07a74ce3bd407487e
        Author: Michael Pasternak 
        Date:   Sat Nov 10 11:03:12 2012 +0200

            sdk: implement generic error delegation infrastructure

            Change-Id: I77b9ef1cb4b281b0d426bcf671f317931f55a82c
            Signed-off-by: Michael Pasternak 

        commit 2c261b74610e4045567e86c0ab213d7b4b098b2c
        Author: Michael Pasternak 
        Date:   Thu Nov 8 17:22:10 2012 +0200

            sdk: implement generic mapping infastructure

            Change-Id: I52139d7097cc9a2a9794dcd1741cd49644bc8442
            Signed-off-by: Michael Pasternak 

        commit ff15762fe52502004070b37516997e7b9ac6d89a
        Author: Michael Pasternak 
        Date:   Thu Nov 8 12:39:13 2012 +0200

            sdk: implement generic serialization infrastructure

            Change-Id: If0818ffeb1e78512c63c7229f5f6e837f84cfbc2
            Signed-off-by: Michael Pasternak 

        commit 0b2e6897a347e41846ec726b23c1e54f312fead1
        Author: Michael Pasternak 
        Date:   Tue Nov 6 15:29:04 2012 +0200

            sdk: cleanup

            Change-Id: I7f309965dc0f6dea5397886666d8a518260773e5
            Signed-off-by: Michael Pasternak 

        commit b0d38440ee3b7d7fd4ef00a8e35527887c179c85
        Author: Michael Pasternak 
        Date:   Tue Nov 6 13:17:20 2012 +0200

            sdk: update gitignore

            Change-Id: I4c928e5cecd645f12471f7b9c9dcb8c54819f27e
            Signed-off-by: Michael Pasternak 

        commit 14d59fe8d4d7daf56a1353f09dfadafea9c8bbfe
        Author: Michael Pasternak 
        Date:   Tue Nov 6 13:15:36 2012 +0200

            sdk: implment http invocation infrustucture

            Change-Id: I3814b5f3f9e40fce3779424f94a688147b57c74a
            Signed-off-by: Michael Pasternak 

        commit d0fa5e4bf32cbff2a8c4b148d3a383c3fb73c7d7
        Author: Michael Pasternak 
        Date:   Mon Nov 5 18:21:49 2012 +0200

            sdk: implement HttpProxyBuilder and move http context to HttpProxy

            Change-Id: I9185e468b9fb2b0a6b568a885030615a93ee6b00
            Signed-off-by: Michael Pasternak 

        commit 90089ba76f17de1d2ff5e386b1546f157731fd35
        Author: Michael Pasternak 
        Date:   Mon Nov 5 15:28:11 2012 +0200

            sdk: add proxy overloads without List

            Change-Id: I281bb9ae885956314b0e170316cb71e419662ec6
            Signed-off-by: Michael Pasternak 

        commit 8027a22801b30a2385806efd9c45c76fc6f5d9a0
        Author: Michael Pasternak 
        Date:   Mon Nov 5 14:55:16 2012 +0200

            sdk: implement HttpProxy

            Change-Id: I72d52f986999048756934c9603304e0fa583d0b2
            Signed-off-by: Michael Pasternak 

        commit f8efee469b7fcaa862284609e2083ab3844181e9
        Author: Michael Pasternak 
        Date:   Mon Nov 5 11:02:43 2012 +0200

            core: implement HttpRequestRetryHandler

            Change-Id: Ie335885c112e167a989497f4d797efa81e97fb82
            Signed-off-by: Michael Pasternak 

        commit 6a57dcd64ab7a6accb680cfc967b7225200c1e6f
        Author: Michael Pasternak 
        Date:   Mon Nov 5 09:42:19 2012 +0200

            sdk: remove *.class

            Change-Id: I6553cdf2b6490ece4fe6ee79f25649b64da13586
            Signed-off-by: Michael Pasternak 

        commit 16d9c955628f5d519de869d4cd4c8fd117ac5694
        Author: Michael Pasternak 
        Date:   Mon Nov 5 09:39:09 2012 +0200

            git: add gitignore

            Change-Id: Ibcd462783b71ef78b4f4f4ff92542cdffc0024d5
            Signed-off-by: Michael Pasternak 

        commit e453ea82cd0b55e942e780be6bad9239616a8a6b
        Author: Michael Pasternak 
        Date:   Mon Nov 5 09:29:15 2012 +0200

            core: implement connections pool watchdog

            Change-Id: Ibba0b390e1f716322f211f61170c0b409eba4e0d
            Signed-off-by: Michael Pasternak 

        commit e9a7cb8a08c546ce8105b5855dd8982526d35947
        Author: Michael Pasternak 
        Date:   Mon Nov 5 09:25:47 2012 +0200

            sdk: remove test file

            Change-Id: I08e5cde5c20d97e58c470664060c5f9344e88ae5
            Signed-off-by: Michael Pasternak 

        commit 3e73e186f12e87acc1670e09cd7db954461c85ad
        Author: Michael Pasternak 
        Date:   Mon Nov 5 09:16:24 2012 +0200

            Initial Import
