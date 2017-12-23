define(["jquery"], function ($) {   
    var SIZE = 32;
    var linksShown = false;

    function showLinks() {
        var container = document.body;
        $("[data-pagelink]").each(function () {
            var htmlElement = document.createElement("div");
            htmlElement.className = "page-link";
            var $this = $(this);
            var pos = $this.offset();
            pos.width = $this.width();
            pos.height = $this.height();
            var style = "left:" + ~~(pos.left + pos.width / 2 - SIZE / 2) + "px";
            style += ";top:" + ~~(pos.top + pos.height / 2 - SIZE / 2) + "px";
            htmlElement.setAttribute("style", style);
            container.appendChild(htmlElement);
        });
        linksShown = true;
    }

    return {
        init: function () {
            $("[data-pagelink]").click(function () {                
                var pageId = $(this).data("pagelink") + ""; //data() method will automatically convert strings to int, but we need strings
                if (document.domain && window.parent !== window.self) {
                    window.parent.require(["previewModel"], function (vm) {
                        vm.content.navigateToPageById(pageId);
                    });
                }
                else {
                    var href = pageId + ".html";
                    if (linksShown) {
                        href += "?showLinks";
                    }
                    location.href = href;
                }
            });

            if (location.search && location.search.indexOf("showLinks") !== -1) {
                showLinks();
            }
        }
    }
});