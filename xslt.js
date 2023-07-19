let transformBtn = document.querySelector("#transformBtn");
let uploadInput = document.querySelector("#uploadInput");
let downloadLink = document.querySelector("#downloadLink");
let fileInput = null
function processTransform(){
    if (fileInput == null){
        console.log("There is no file input");
        return false;
    }
    SaxonJS.transform({
        stylesheetLocation: "cmme_to_mei.sef.json",
        //sourceLocation: "/cmme/Berchem-OFelixRegina.cmme.xml",
        sourceNode: fileInput,
        destination: "serialized",
        outputProperties: {
            method: "xml",
            indent: true,
            encoding: "utf-8"
        }
    }, "async").then(e => {
        let filename = uploadInput.files[0].name;
        filename = filename.split(".");
        filename = filename[0]+".mei"
        let file = new File([e.principalResult], 
            filename, {type: 'text/xml'}
        )
        console.log(file.type)
        let url = URL.createObjectURL(file)
        downloadLink.href = url;
        downloadLink.download = file.name;
        console.log(e)
    });
}

function loadFile(e){
    if (e.target.files.length < 1) {
        fileInput = null;
        return false;
    }
    let f = e.target.files[0];
    let reader = new FileReader();
    reader.onload = function(e){
        readXML = e.target.result;
        var parser = new DOMParser();
        var doc = parser.parseFromString(readXML, "application/xml");
        fileInput = doc

    }
    reader.readAsText(f)
}

uploadInput.addEventListener("change", loadFile, false);

transformBtn.addEventListener("click", processTransform, false);

