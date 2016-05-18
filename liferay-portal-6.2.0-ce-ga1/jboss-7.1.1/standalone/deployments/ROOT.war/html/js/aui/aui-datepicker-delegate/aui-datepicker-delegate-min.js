YUI.add("aui-datepicker-delegate",function(e,t){function y(){}var n=e.Lang,r=n.isString,i=e.one(e.config.doc),s="activeInput",o="blur",u="click",a="container",f="dateSeparator",l="datepickerSelection",c="focus",h="mask",p="mousedown",d="selectionChange",v="trigger",m="valueExtractor",g="valueFormatter";y.prototype={_eventHandles:null,_userInteractionInProgress:!1,initializer:function(){var e=this;e.bindDelegateUI()},destroy:function(){var t=this;(new e.EventHandle(t._eventHandles)).detach()},bindDelegateUI:function(){var t=this,n=t.get(a),r=t.get(v);t._eventHandles=[n.delegate([c,p],e.bind("_onceUserInteraction",t),r),n.delegate(o,e.bind("_onUserInteractionRelease",t),r),n.delegate(u,e.bind("_onceUserInteractionRelease",t),r)],t.publish(d,{defaultFn:t._defSelectionChangeFn})},getSelectedDates:function(e){var t=this,n=e||t.get(s),r=n.getData(l);return r?r:null},getParsedDatesFromInputValue:function(t){var n=this,r=n.get(m),i=r.call(n,t);return i?e.Array.filter(i,function(e){return e!==!1}):null},useInputNode:function(){},useInputNodeOnce:function(e){var t=this;t._userInteractionInProgress||t.useInputNode(e)},_defSelectionChangeFn:function(e){var t=this,n=e.newSelection,r=t.get(s),i=t.get(g);i.call(t,n),r.setData(l,n)},_formatDate:function(t){var n=this,r=n.get(h);return e.Date.format(t,{format:r})},_onceUserInteraction:function(e){var t=this;t.useInputNodeOnce(e.currentTarget),t._userInteractionInProgress=!0},_onceUserInteractionRelease:function(e){var t=this;t.useInputNodeOnce(e.currentTarget),t._userInteractionInProgress=!1},_onUserInteractionRelease:function(e){var t=this;t.useInputNode(e.currentTarget),t._userInteractionInProgress=!1},_valueExtractorFn:function(){return function(t){var r=this,i=r.get(s),o=n.trim(t||i.val()),u=r.get(f),a=r.get(h),l;return o&&(l=[],e.Array.each(o.split(u),function(t){t=n.trim(t),t&&l.push(e.Date.parse(a,t))})),l}},_valueFormatterFn:function(){return function(t){var n=this,r=n.get(s),i=n.get(f),o=[];e.Array.each(t,function(e){o.push(n._formatDate(e))}),r.val(o.join(i))}}},y.ATTRS={activeInput:{},container:{setter:e.one,value:i,writeOnce:!0},dateSeparator:{value:" \u2014 ",validator:n.isString},mask:{value:"%m/%d/%Y",validator:n.isString},trigger:{validator:r,writeOnce:!0},valueExtractor:{valueFn:"_valueExtractorFn",validator:n.isFunction},valueFormatter:{valueFn:"_valueFormatterFn",validator:n.isFunction}},e.DatePickerDelegate=y},"2.0.0",{requires:["node-event-delegate","event-focus","aui-event-input","aui-datatype-date-parse"]});
