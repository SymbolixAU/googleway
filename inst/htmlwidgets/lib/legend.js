
function add_legend(map_id, layer_id, legendValues, legendOptions) {
    var i = 0;
    
    for (i = 0; i < legendValues.length; i++){

        if (legendValues[i].type === "category") {
            add_legend_category(map_id, layer_id, legendValues[i], legendOptions);
        } else {
            add_legend_gradient(map_id, layer_id, legendValues[i], legendOptions);
        }
    }
    
//    if (legendOptions.type === "gradient") {
//        add_legend_gradient(map_id, layer_id, legendValues, legendOptions);
//    } else {
//        add_legend_category(map_id, layer_id, legendValues, legendOptions);
//    }
}

// TODO:
// - label formats
function add_legend_gradient(map_id, layer_id, legendValues, legendOptions) {
    // fill gradient
    
    if (window[map_id + 'legend' + layer_id + legendValues.colourType] === undefined) {
        window[map_id + 'legend' + layer_id + legendValues.colourType] = document.createElement("div");
        window[map_id + 'legend' + layer_id + legendValues.colourType].setAttribute('id', map_id + 'legend' + layer_id + legendValues.colourType);
        window[map_id + 'legend' + layer_id + legendValues.colourType].setAttribute('class', 'legend');
    }

    var legendContent = document.createElement("div"),
        legendTitle = document.createElement("div"),
        tickContainer = document.createElement("div"),
        labelContainer = document.createElement("div"),
        legendColours = document.createElement('div'),
        jsColours = [],
        colours = '',
        i = 0,
        style = '';
    
    legendContent.setAttribute('class', 'legendContent');
    
    legendTitle.setAttribute('class', 'legendTitle');
    legendTitle.innerHTML = legendValues.title;
    //legendTitle.innerHTML = (legendOptions.title !== undefined) ? legendOptions.title : "placeholder title";
    window[map_id + 'legend' + layer_id + legendValues.colourType].appendChild(legendTitle);
     
    tickContainer.setAttribute('class', 'labelContainer');
    labelContainer.setAttribute('class', 'labelContainer');

    if (legendOptions.css !== null) {
        window[map_id + 'legend' + layer_id + legendValues.colourType].setAttribute('style', legendOptions.css);
    }

    for (i = 0; i < legendValues.legend.colour.length; i++) {
        jsColours.push(legendValues.legend.colour[i]);
    }
    
    colours = '(' + jsColours.join() + ')';

    style = 'display: inline-block; height: ' + jsColours.length * 20 + 'px; width: 15px;';
    style += 'background: ' + jsColours[1] + ';';
    style += 'background: -webkit-linear-gradient' + colours + ';';
    style += 'background: -o-linear-gradient' + colours + ';';
    style += 'background: -moz-linear-gradient' + colours + ';';
    style += 'background: linear-gradient' + colours + ';';

    legendColours.setAttribute('style', style);
    legendContent.appendChild(legendColours);

    for (i = 0; i < legendValues.legend.colour.length; i++) {
        
        var legendValue = 'text-align: left; color: #b8b9ba; font-size: 12px; height: 20px;',
            divTicks = document.createElement('div'),
            divVal = document.createElement('div');

        divTicks.setAttribute('style', legendValue);
        divTicks.innerHTML = '-';
        tickContainer.appendChild(divTicks);

        divVal.setAttribute('style', legendValue);
        divVal.innerHTML = legendValues.legend.variable[i];
        labelContainer.appendChild(divVal);
    }
    
    legendContent.appendChild(tickContainer);
    legendContent.appendChild(labelContainer);

    window[map_id + 'legend' + layer_id + legendValues.colourType].appendChild(legendContent);
    
    placeLegend(map_id, window[map_id + 'legend' + layer_id + legendValues.colourType], legendOptions.position);
}

function generateColourBox(colourType, colour){
    if(colourType === "fill_colour"){
        return ('height: 20px; width: 15px; background: ' + colour);
    }else{
        // http://jsfiddle.net/UES6U/2/
        return ('height: 20px; width: 15px; background: linear-gradient(to bottom, white 40%, ' + colour + ' 40%, ' + colour + ' 60%, ' + 'white 60%)')
    }
}

function add_legend_category(map_id, layer_id, legendValues, legendOptions) {

    if (window[map_id + 'legend' + layer_id + legendValues.colourType] === undefined) {
        window[map_id + 'legend' + layer_id + legendValues.colourType] = document.createElement("div");
        window[map_id + 'legend' + layer_id + legendValues.colourType].setAttribute('id', map_id + 'legend' + layer_id + legendValues.colourType);
        window[map_id + 'legend' + layer_id + legendValues.colourType].setAttribute('class', 'legend');
    }
    
    var legendContent = document.createElement("div"),
        legendTitle = document.createElement("div"),
        colourContainer = document.createElement("div"),
        tickContainer = document.createElement("div"),
        labelContainer = document.createElement("div"),
        legendColours = document.createElement('div'),
        //colourAttribute = '',
        i = 0;
    
    legendContent.setAttribute('class', 'legendContent');
    
    legendTitle.setAttribute('class', 'legendTitle');
    //legendTitle.innerHTML = (legendOptions.title !== null) ? legendOptions.title : legendValues.title;
    legendTitle.innerHTML = legendValues.title;
    window[map_id + 'legend' + layer_id + legendValues.colourType].appendChild(legendTitle);
    
    colourContainer.setAttribute('class', 'labelContainer');
    tickContainer.setAttribute('class', 'labelContainer');
    labelContainer.setAttribute('class', 'labelContainer');

    for (i = 0; i < legendValues.legend.colour.length; i++) {

        var tickVal = 'text-left: center; color: #b8b9ba; font-size: 12px; height: 20px;',
            divCol = document.createElement('div'),
            divTicks = document.createElement('div'),
            divVal = document.createElement('div');

        //colourBox = 'height: 20px; width: 15px; background: ' + legendValues.legend.colour[i];
        colourBox = generateColourBox(legendValues.colourType, legendValues.legend.colour[i]);
        divCol.setAttribute('style', colourBox);
        colourContainer.appendChild(divCol);

        divTicks.setAttribute('style', tickVal);
        divTicks.innerHTML = '-';
        tickContainer.appendChild(divTicks);

        divVal.setAttribute('style', tickVal);
        divVal.innerHTML = legendValues.legend.variable[i];
        labelContainer.appendChild(divVal);
    }

    legendContent.appendChild(colourContainer);
    legendContent.appendChild(tickContainer);
    legendContent.appendChild(labelContainer);
    
    window[map_id + 'legend' + layer_id + legendValues.colourType].appendChild(legendContent);
    
    placeLegend(map_id, window[map_id + 'legend' + layer_id + legendValues.colourType], legendOptions.position); 
}

function placeLegend(map_id, legend, position) {

    switch (position) {
    case 'RIGHT_BOTTOM':
        window[map_id + 'map'].controls[google.maps.ControlPosition.RIGHT_BOTTOM].push(legend);
        break;
    case 'TOP_CENTER':
        window[map_id + 'map'].controls[google.maps.ControlPosition.TOP_CENTER].push(legend);
        break;
    case 'TOP_LEFT':
        window[map_id + 'map'].controls[google.maps.ControlPosition.TOP_LEFT].push(legend);
        break;
    case 'LEFT_TOP':
        window[map_id + 'map'].controls[google.maps.ControlPosition.LEFT_TOP].push(legend);
        break;
    case 'RIGHT_TOP':
        window[map_id + 'map'].controls[google.maps.ControlPosition.RIGHT_TOP].push(legend);
        break;
    case 'LEFT_CENTER':
        window[map_id + 'map'].controls[google.maps.ControlPosition.LEFT_CENTER].push(legend);
        break;
    case 'RIGHT_CENTER':
        window[map_id + 'map'].controls[google.maps.ControlPosition.RIGHT_CENTER].push(legend);
        break;
    case 'LEFT_BOTTOM':
        window[map_id + 'map'].controls[google.maps.ControlPosition.LEFT_BOTTOM].push(legend);
        break;
    case 'BOTTOM_CENTER':
        window[map_id + 'map'].controls[google.maps.ControlPosition.BOTTOM_CENTER].push(legend);
        break;
    case 'BOTTOM_LEFT':
        window[map_id + 'map'].controls[google.maps.ControlPosition.BOTTOM_LEFT].push(legend);
        break;
    case 'BOTTOM_RIGHT':
        window[map_id + 'map'].controls[google.maps.ControlPosition.BOTTOM_RIGHT].push(legend);
        break;
    default:
        window[map_id + 'map'].controls[google.maps.ControlPosition.RIGHT_BOTTOM].push(legend);
        break;
    }
}

