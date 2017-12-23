(function () {
    var COMMON_FILES_PATH = "../common-files/";

    function commonFilePath(file) {
        return COMMON_FILES_PATH + file;
    }

    requirejs.config({
        paths: {
            "ko": commonFilePath("js/knockout-2.2.1"),
            "jquery": commonFilePath("js/jquery-1.11.min"),
            "bootstrap": commonFilePath("js/bootstrap.min")
        },
        shim: {
            "jquery": { exports: "jQuery" },
            "bootstrap": { deps: ["jquery"] },
            "ko": { deps: ["jquery"] }
        },
        deps: ["bootstrap"],
        callback: run
    });

    function run() {
        require(["previewModel", "pageLinksModule"], function (viewModel, pageLinks) {
            viewModel.init(document.body);
            pageLinks.init();
        });
    }
}());