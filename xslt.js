let transformBtn = document.querySelector("#transformBtn");
let uploadInput = document.querySelector("#uploadInput");
let downloadLink = document.querySelector("#downloadLink");
let fileInput = null
function processTransform(){
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
        let file = new File([e.principalResult], 
            'test.mei', {type: 'text/xml'}
        )
        console.log(file.type)
        let url = URL.createObjectURL(file)
        downloadLink.href = url;
        downloadLink.download = file.name;
        console.log(e)
    });
}

function loadFile(e){
    let f = e.target.files[0];
    let reader = new FileReader();
    reader.onload = function(e){
        readXML = e.target.result;
        var parser = new DOMParser();
        var doc = parser.parseFromString(readXML, "application/xml");
        fileInput = doc

    }
    reader.readAsText(f)
    console.log("tis worked")
}

uploadInput.addEventListener("change", loadFile, false);

transformBtn.addEventListener("click", processTransform, false);

