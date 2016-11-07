<#include "DefaultScreenMacros.html.ftl"/>

<#macro file><input type="file" class="form-control" name="<@fieldName .node/>"<#if .node["@allowMultiple"]! == "true"> multiple="multiple"</#if> value="${sri.getFieldValueString(.node?parent?parent, .node["@default-value"]!"", null)?html}" size="${.node.@size!"30"}"<#if .node.@maxlength?has_content> maxlength="${.node.@maxlength}"</#if><#if .node?parent["@tooltip"]?has_content> data-toggle="tooltip" title="${ec.getResource().expand(.node?parent["@tooltip"], "")}"</#if>></#macro>

<#macro "bootstrap-tagsinput">
     <#assign fieldValue = sri.getFieldValueString(.node?parent?parent, .node["@default-value"]!"", .node["@format"]!)>
     <#assign id><@fieldId .node/></#assign>
         <input id=${id}
             type="text"
             class="form-control"
             data-role="tagsinput"
             value="${fieldValue?html}"
             name="<@fieldName .node/>"
         />
 </#macro>

<#macro paginationHeader formListInfo formId isHeaderDialog>
    <#assign formNode = formListInfo.getFormNode()>
    <#assign mainColInfoList = formListInfo.getMainColInfo()>
    <#assign numColumns = (mainColInfoList?size)!100>
    <#if numColumns == 0><#assign numColumns = 100></#if>
    <#assign isSavedFinds = formNode["@saved-finds"]! == "true">
    <#assign isSelectColumns = formNode["@select-columns"]! == "true">
    <#assign isPaginated = !(formNode["@paginate"]! == "false") && context[listName + "Count"]?? && (context[listName + "Count"]! > 0) &&
            (!formNode["@paginate-always-show"]?has_content || formNode["@paginate-always-show"]! == "true" || (context[listName + "PageMaxIndex"] > 0))>
    <#if (isHeaderDialog || isSavedFinds || isSelectColumns || isPaginated) && hideNav! != "true">
        <tr class="form-list-nav-row"><th colspan="${numColumns}">
        <nav class="form-list-nav">
            <#if isSavedFinds>
                <#assign userFindInfoList = formListInfo.getUserFormListFinds(ec)>
                <#if userFindInfoList?has_content>
                    <#assign quickSavedFindId = formId + "_QuickSavedFind">
                    <select id="${quickSavedFindId}">
                        <option></option><#-- empty option for placeholder -->
                        <option value="_clear" data-action="${sri.getScreenUrlInstance().url}">${ec.getL10n().localize("Clear Current Find")}</option>
                        <#list userFindInfoList as userFindInfo>
                            <#assign formListFind = userFindInfo.formListFind>
                            <#assign findParameters = userFindInfo.findParameters>
                            <#assign doFindUrl = sri.getScreenUrlInstance().cloneUrlInstance().addParameters(findParameters).removeParameter("pageIndex").removeParameter("moquiFormName").removeParameter("moquiSessionToken")>
                            <option value="${formListFind.formListFindId}"<#if formListFind.formListFindId == ec.getContext().formListFindId!> selected="selected"</#if> data-action="${doFindUrl.urlWithParams}">${userFindInfo.description?html}</option>
                        </#list>
                    </select>
                    <script>
                        $("#${quickSavedFindId}").select2({ ${select2DefaultOptions}, placeholder:'${ec.getL10n().localize("Saved Finds")}' });
                        $("#${quickSavedFindId}").on('select2:select', function(evt) {
                            var dataAction = $(evt.params.data.element).attr("data-action");
                            if (dataAction) window.open(dataAction, "_self");
                        } );
                    </script>
                </#if>
            </#if>
            <#if isSavedFinds || isHeaderDialog><button id="${headerFormDialogId}_button" type="button" data-toggle="modal" data-target="#${headerFormDialogId}" data-original-title="${headerFormButtonText}" data-placement="bottom" class="btn btn-default"><i class="glyphicon glyphicon-share"></i> ${headerFormButtonText}</button></#if>
            <#if isSelectColumns><button id="${selectColumnsDialogId}_button" type="button" data-toggle="modal" data-target="#${selectColumnsDialogId}" data-original-title="${ec.getL10n().localize("Columns")}" data-placement="bottom" class="btn btn-default"><i class="glyphicon glyphicon-share"></i> ${ec.getL10n().localize("Columns")}</button></#if>

            <#if isPaginated>
                <#assign curPageIndex = context[listName + "PageIndex"]>
                <#assign curPageMaxIndex = context[listName + "PageMaxIndex"]>
                <#assign prevPageIndexMin = curPageIndex - 3><#if (prevPageIndexMin < 0)><#assign prevPageIndexMin = 0></#if>
                <#assign prevPageIndexMax = curPageIndex - 1><#assign nextPageIndexMin = curPageIndex + 1>
                <#assign nextPageIndexMax = curPageIndex + 3><#if (nextPageIndexMax > curPageMaxIndex)><#assign nextPageIndexMax = curPageMaxIndex></#if>
                <ul class="pagination">
                <#if (curPageIndex > 0)>
                    <#assign firstUrlInfo = sri.getScreenUrlInstance().cloneUrlInstance().addParameter("pageIndex", 0)>
                    <#assign previousUrlInfo = sri.getScreenUrlInstance().cloneUrlInstance().addParameter("pageIndex", (curPageIndex - 1))>
                    <li><a href="${firstUrlInfo.getUrlWithParams()}"><i class="glyphicon glyphicon-fast-backward"></i></a></li>
                    <li><a href="${previousUrlInfo.getUrlWithParams()}"><i class="glyphicon glyphicon-backward"></i></a></li>
                <#else>
                    <li><span><i class="glyphicon glyphicon-fast-backward"></i></span></li>
                    <li><span><i class="glyphicon glyphicon-backward"></i></span></li>
                </#if>

                <#if (prevPageIndexMax >= 0)><#list prevPageIndexMin..prevPageIndexMax as pageLinkIndex>
                    <#assign pageLinkUrlInfo = sri.getScreenUrlInstance().cloneUrlInstance().addParameter("pageIndex", pageLinkIndex)>
                    <li><a href="${pageLinkUrlInfo.getUrlWithParams()}">${pageLinkIndex + 1}</a></li>
                </#list></#if>
                <#assign paginationTemplate = ec.getL10n().localize("PaginationTemplate")?interpret>
                <li><a href="${sri.getScreenUrlInstance().getUrlWithParams()}"><@paginationTemplate /></a></li>

                <#if (nextPageIndexMin <= curPageMaxIndex)><#list nextPageIndexMin..nextPageIndexMax as pageLinkIndex>
                    <#assign pageLinkUrlInfo = sri.getScreenUrlInstance().cloneUrlInstance().addParameter("pageIndex", pageLinkIndex)>
                    <li><a href="${pageLinkUrlInfo.getUrlWithParams()}">${pageLinkIndex + 1}</a></li>
                </#list></#if>

                <#if (curPageIndex < curPageMaxIndex)>
                    <#assign lastUrlInfo = sri.getScreenUrlInstance().cloneUrlInstance().addParameter("pageIndex", curPageMaxIndex)>
                    <#assign nextUrlInfo = sri.getScreenUrlInstance().cloneUrlInstance().addParameter("pageIndex", curPageIndex + 1)>
                    <li><a href="${nextUrlInfo.getUrlWithParams()}"><i class="glyphicon glyphicon-forward"></i></a></li>
                    <li><a href="${lastUrlInfo.getUrlWithParams()}"><i class="glyphicon glyphicon-fast-forward"></i></a></li>
                <#else>
                    <li><span><i class="glyphicon glyphicon-forward"></i></span></li>
                    <li><span><i class="glyphicon glyphicon-fast-forward"></i></span></li>
                </#if>
                </ul>
                <#if (curPageMaxIndex > 4)>
                    <#assign goPageUrl = sri.getScreenUrlInstance().cloneUrlInstance().removeParameter("pageIndex").removeParameter("moquiFormName").removeParameter("moquiSessionToken")>
                    <#assign goPageUrlParms = goPageUrl.getParameterMap()>
                    <form class="form-inline" id="${formId}_GoPage" method="post" action="${goPageUrl.getUrl()}">
                        <#list goPageUrlParms.keySet() as parmName>
                            <input type="hidden" name="${parmName}" value="${goPageUrlParms.get(parmName)!?html}"></#list>
                        <div class="form-group">
                            <label class="sr-only" for="${formId}_GoPage_pageIndex">Page Number</label>
                            <input type="text" class="form-control" size="6" name="pageIndex" id="${formId}_GoPage_pageIndex" placeholder="${ec.getL10n().localize("Page #")}">
                        </div>
                        <button type="submit" class="btn btn-default">${ec.getL10n().localize("Go##Page")}</button>
                    </form>
                    <script>
                        $("#${formId}_GoPage").validate({ errorClass: 'help-block', errorElement: 'span',
                            rules: { pageIndex: { required:true, min:1, max:${(curPageMaxIndex + 1)?c} } },
                            highlight: function(element, errorClass, validClass) { $(element).parents('.form-group').removeClass('has-success').addClass('has-error'); },
                            unhighlight: function(element, errorClass, validClass) { $(element).parents('.form-group').removeClass('has-error').addClass('has-success'); },
                            <#-- show 1-based index to user but server expects 0-based index -->
                            submitHandler: function(form) { $("#${formId}_GoPage_pageIndex").val($("#${formId}_GoPage_pageIndex").val() - 1); form.submit(); }
                        });
                    </script>
                </#if>
                <#if formNode["@show-all-button"]! == "true" && (context[listName + 'Count'] < 500)>
                    <#if context["pageNoLimit"]?has_content>
                        <#assign allLinkUrl = sri.getScreenUrlInstance().cloneUrlInstance().removeParameter("pageNoLimit")>
                        <a href="${allLinkUrl.getUrlWithParams()}" class="btn btn-default">Paginate</a>
                    <#else>
                        <#assign allLinkUrl = sri.getScreenUrlInstance().cloneUrlInstance().addParameter("pageNoLimit", "true")>
                        <a href="${allLinkUrl.getUrlWithParams()}" class="btn btn-default">Show All</a>
                    </#if>
                </#if>
            </#if>

            <form class="form-inline">
                <div class="btn-group">
                    <#if formNode["@show-csv-button"]! == "true">
                        <#assign csvLinkUrl = sri.getScreenUrlInstance().cloneUrlInstance().addParameter("renderMode", "csv")
                                .addParameter("pageNoLimit", "true").addParameter("lastStandalone", "true").addParameter("saveFilename", formNode["@name"] + ".csv")>
                        <a href="${csvLinkUrl.getUrlWithParams()}" class="btn btn-default">${ec.getL10n().localize("CSV")}</a>
                    </#if>
                    <#if formNode["@show-text-button"]! == "true">
                        <#assign showTextDialogId = formId + "_TextDialog">
                        <button id="${showTextDialogId}_button" type="button" data-toggle="modal" data-target="#${showTextDialogId}" data-original-title="${ec.getL10n().localize("Text")}" data-placement="bottom" class="btn btn-default"><i class="glyphicon glyphicon-share"></i> ${ec.getL10n().localize("Text")}</button>
                    </#if>
                    <#if formNode["@show-pdf-button"]! == "true">
                        <#assign showPdfDialogId = formId + "_PdfDialog">
                        <button id="${showPdfDialogId}_button" type="button" data-toggle="modal" data-target="#${showPdfDialogId}" data-original-title="${ec.getL10n().localize("PDF")}" data-placement="bottom" class="btn btn-default"><i class="glyphicon glyphicon-share"></i> ${ec.getL10n().localize("PDF")}</button>
                    </#if>
                    <#if .node["@button-content-to-display"]! == "true">
                        <input id="InvoiceList_TotalsDisplay_input" type="text" class="btn btn-primary disabled" name="totalsDisplay_input" value=""/>
                    </#if>
                </div>
            </form>
        </nav>
        </th></tr>
    </#if>
</#macro>