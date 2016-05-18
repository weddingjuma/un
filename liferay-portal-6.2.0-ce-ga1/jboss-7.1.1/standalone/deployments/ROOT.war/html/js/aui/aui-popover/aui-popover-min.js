YUI.add("aui-popover",function(e,t){var n=e.WidgetStdMod,r="ownerDocument",i=e.getClassName,s=" ",o="arrow",u="block",a="boundingBox",f="click",l="content",c="contentBox",h="display",p="none",d="popover",v=i(o),m=i("popover-content"),g=i("popover-footer"),y=i("popover-title");e.Popover=e.Base.create(d,e.Widget,[e.WidgetCssClass,e.WidgetPosition,e.WidgetStdMod,e.WidgetToggle,e.WidgetAutohide,e.WidgetToolbars,e.WidgetModality,e.WidgetPositionAlign,e.WidgetPositionAlignSuggestion,e.WidgetPositionConstrain,e.WidgetStack,e.WidgetTrigger],{initializer:function(){var t=this;e.after(t._afterUiSetVisible,t,"_uiSetVisible"),e.after(t._afterRenderBoxClassNames,t,"_renderBoxClassNames")},renderUI:function(){var t=this,n=t.get(a);n.append(e.Popover.TEMPLATES.arrow),t.suggestAlignment()},_afterRenderBoxClassNames:function(){var e=this,t=e.get(c);t.removeClass(e.getClassName(l))},_afterUiSetVisible:function(e){var t=this,n=t.get(a);n.setStyle(h,e?u:p)},_getStdModTemplate:function(t){return e.Node.create(e.Popover.TEMPLATES[t],this._stdModNode.get(r))}},{CSS_PREFIX:i(d),ATTRS:{triggerToggleEvent:{value:f}},TEMPLATES:{header:'<div class="'+n.SECTION_CLASS_NAMES[n.HEADER]+s+y+'"></div>',body:'<div class="'+n.SECTION_CLASS_NAMES[n.BODY]+s+m+'"></div>',footer:'<div class="'+n.SECTION_CLASS_NAMES[n.FOOTER]+s+g+'"></div>',arrow:'<div class="'+v+'"></div>'}})},"2.0.0",{requires:["transition","widget","widget-autohide","widget-buttons","widget-modality","widget-position","widget-position-align","widget-position-constrain","widget-stack","widget-stdmod","aui-classnamemanager","aui-widget-cssclass","aui-widget-toggle","aui-widget-toolbars","aui-widget-trigger","aui-widget-position-align-suggestion","aui-component","aui-node-base"]});