package towser.platform.client;

import towser.platform.DomBuilder;
import towser.platform.LazyMap;

#if !backend
class ClientTowser<Model, Msg>
{
    public var markup (default, null) :String = "";
    
    /**
     * [Description]
     * @param element - Root element ID
     * @param update - State Update Function
     * @param view  - State View Function
     * @param model - State
     */
    public function new(towser :Towser<Model, Msg>, element :String, update :Towser<Model, Msg> -> Msg -> Model -> Bool, view :Model -> RenderFunction<Model, Msg>, model :Model) : Void
    {
        _update = update;
        _view = view;
        _model = model;
        init(element, towser);
    }

    public function update(msg :Msg, towser :Towser<Model, Msg>) : Void
    {
        if(_update(towser, msg, _model)) {
            render(towser);
        }
    }

    public inline function render(towser :Towser<Model, Msg>) : Void
    {
        DomBuilder.patch(_element, _view(_model), towser);
    }

    public inline function getModel() : Model
    {
        return _model;
    }

    public inline function setModel(model :Model) : Void
    {
        _model = model;
    }

    private function init(element :String, towser :Towser<Model, Msg>) : Void
    {
        _element = js.Browser.document.getElementById(element);
        DomBuilder.patch(_element, _view(_model), towser);
    }

    private var _update : Towser<Model, Msg> -> Msg -> Model -> Bool;
    private var _view :Model -> RenderFunction<Model, Msg>;
    private var _model :Model;
    private var _element :js.html.Element;
}
#end