package engine;

import js.html.ImageElement;
import js.Browser;
import js.lib.Promise;
import engine.display.Canvas;

class Assets
{
    private function new(images :Map<String, ImageElement>) : Void
    {
        _images = images;
    }

    public function getImage(name :String) : ImageElement
    {
        return _images.get(name);
    }

    public static function load(textures :Array<Texture>) : Promise<Assets>
    {
        var images = new Map<String, ImageElement>();
        var loadedCount = 0;
        return new Promise((resolve, reject) -> {
            for(texture in textures) {
                var name = texture.name;
                createImage(texture.width, texture.height, texture.draw, (image) -> {
                    images.set(name, image);
                    if(++loadedCount == textures.length) {
                        resolve(new Assets(images));
                    }
                });
            }
        });
    }

    private static function createImage(width :Int, height :Int, draw :Canvas -> Void, onComplete : ImageElement -> Void) : Void
    {
        var canvas = Browser.document.createCanvasElement();
        canvas.width = width;
        canvas.height = height;
        draw(new Canvas(canvas));

        var dataUrl = canvas.toDataURL();
        var img = Browser.document.createImageElement();
        img.onload = image -> {
            onComplete(image);
        };
        img.src = dataUrl;
        img.width = width;
        img.height = height;
    }

    private var _images :Map<String, ImageElement>;
}

typedef Texture = {name :String, width :Int, height :Int, draw :Canvas -> Void};