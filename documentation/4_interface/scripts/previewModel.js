define(["ko", "metadata"], function (ko, metadata) {
    var model;
    return model = {
        init: function (element) {
            this.content.init();
            this.sidebar.init();
            ko.applyBindings(this, element);
        },
        sidebar: {
            pageGroups: ko.observable(),
            downloadLink: ko.observable(),
            showLinks: ko.observable(true),

            init: function () {
                this.pageGroups(metadata.pageGroups);
                this.downloadLink(metadata.downloadLink);
                this.showLinks.subscribe(function () {
                    model.content.refreshPage();
                });
            },
            selectPage: function (page) {
                model.content.navigateToPage(page);
            }
        },
        content: {
            pageUrl: ko.observable(),
            init: function () {
                var firstPage;
                metadata.forEachPage(function (page) {
                    if (!firstPage) {
                        firstPage = page;
                    }
                    page.selected = ko.observable(false);
                });
                var startupPageId = metadata.startupPageId;
                if (!startupPageId && location.hash) {
                    startupPageId = parseInt(location.hash.substr(1));
                }
                var startupPage = metadata.findPageById(startupPageId);
                if (!startupPage) {
                    startupPage = firstPage;
                }
                this.navigateToPage(startupPage);
            },
            navigateToPageById: function (pageId) {
                var page = metadata.findPageById(pageId);
                if (page) {
                    this.navigateToPage(page);
                }
            },
            navigateToPage: function (page) {
                if (this._selectedPage) {
                    this._selectedPage.selected(false);
                }
                this._selectedPage = page;
                this._selectedPage.selected(true);
                var pageUrl = "pages/" + page.id + ".html";
                if (model.sidebar.showLinks()) {
                    pageUrl += "?showLinks";
                }
                this.pageUrl(pageUrl);
                if (document.domain) {
                    location.hash = page.id;
                }
            },
            refreshPage: function () {
                this.navigateToPage(this._selectedPage);
            }
        }
    }
});