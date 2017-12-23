define(function(){
    return {
        pageGroups: [{"id":"00327e1c-7339-aa72-5815-b224b6aa953d","name":"Default group","pages":[{"id":"639b9755-c7ad-17d4-f6d3-e6c71bedba50","name":"Copy of Create Artist"}]},{"id":"8005e420-b4f8-9076-a729-0ddb046ab4a0","name":"Stock Albums","pages":[{"id":"ee5f7555-c697-ceb6-facd-6831cfcd4ad1","name":"Stock Albums"},{"id":"1db0c36f-67e5-7ac3-0f61-30d41f840269","name":"Create Stock"},{"id":"f0ef9c13-c207-7240-61a0-470c72ade078","name":"Modify Stock"},{"id":"47f9f3f9-eabd-10e4-34b9-6f7ea2d0a097","name":"Delete Stock"}]},{"id":"6f2028b1-3782-c9ed-302c-9e994bf45736","name":"Artists","pages":[{"id":"ecd81207-c0fe-f5be-bc20-f064e20e0036","name":"Artists list"},{"id":"44cd0105-f0b5-cb42-5c05-e204f27b825b","name":"Create Artist"},{"id":"544fa920-2cf6-83d2-79f9-4593111cb284","name":"Modify Artist"},{"id":"d9cfd5c1-3c66-670f-ea7f-4ee748c0d734","name":"Delete Artist"}]},{"id":"6d1e46e5-0b21-624f-a8af-aa9b974700b5","name":"Genres","pages":[{"id":"fcf6b123-185d-8ed3-1be9-f5b0d36b82bc","name":"Genres list"},{"id":"a0f2f327-45ca-2405-cb97-6d55439b2209","name":"Create Genre"},{"id":"05bb0c07-418d-754f-36e2-765752ccf399","name":"Modify Genre"},{"id":"eb568ff2-b61e-349a-658a-01cc3cc50ab5","name":"Delete Genre"}]},{"id":"c566eb50-bd0f-395a-224d-020cb8c6d901","name":"Customer","pages":[{"id":"c5c96eeb-cdf3-55a1-61c4-de4cad3332d5","name":"Customers list"},{"id":"7f46cca9-aa54-6f0d-ea2c-b424038a42c3","name":"Create customer"},{"id":"f14113e0-06d6-35a3-69a6-5edf8e306e33","name":"Modify customer"},{"id":"cb60a94a-b3f8-2344-ec4c-25d0793d0734","name":"Delete customer"}]},{"id":"e1209abe-0066-6404-9593-d510dabc9bfa","name":"Suppliers","pages":[{"id":"e08ddf4a-a95b-1c46-55cb-7d5d7054bbfc","name":"Suppliers list"},{"id":"346b337c-0186-0a4e-ffd3-7bf96bb00863","name":"Create Supplier"},{"id":"c356110d-6576-c376-525e-1d00e342a519","name":"Modify Supplier"},{"id":"51ba3b6e-571b-60ac-900e-304105b21d2a","name":"Delete Supplier"}]},{"id":"dfaa8a5c-1d70-fad5-e45f-2cb5c9e06e05","name":"Sales","pages":[{"id":"2e770128-81ac-2e8d-6a12-78b871f497d5","name":"Sales list"},{"id":"89ac4bec-5336-73b6-eeaf-d169592a3d82","name":"Create a Sale"},{"id":"2765e78e-473e-8375-89a0-86200caf05e0","name":"Modify a Sale"},{"id":"034635b5-7872-b542-e759-830e226314d7","name":"Delete a Sale"}]},{"id":"8a78fa18-69a0-6650-39d4-0348b129a016","name":"Purchase orders","pages":[{"id":"598bdeaa-5391-7a69-b414-ab1ef2ff6b2d","name":"Purchase orders list"},{"id":"1a28d0de-2d18-2b7f-0312-a4aca2cc50bf","name":"Create a purchase order"},{"id":"33cd8032-3419-7c1d-c2f6-afc8dc2a29ee","name":"Modify a purchase order"},{"id":"e2f13cdd-8b85-5133-3126-6ccf5a423ed1","name":"Delete a purchase order"}]}],
        downloadLink: "//services.ninjamock.com/html/htmlExport/download?shareCode=8MW8CWx&projectName=Untitled project",
        startupPageId: 0,

        forEachPage: function(func, thisArg){
        	for (var i = 0, l = this.pageGroups.length; i < l; ++i){
                var group = this.pageGroups[i];
                for (var j = 0, k = group.pages.length; j < k; ++j){
                    var page = group.pages[j];
                    if (func.call(thisArg, page) === false){
                    	return;
                    }
                }
            }
        },
        findPageById: function(pageId){
        	var result;
        	this.forEachPage(function(page){
        		if (page.id === pageId){
        			result = page;
        			return false;
        		}
        	});
        	return result;
        }
    }
});
