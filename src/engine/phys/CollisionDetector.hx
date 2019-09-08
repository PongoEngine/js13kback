package engine.phys;

import engine.display.Sprite;
import engine.phys.ecs.Phys;
import engine.Entity;


class CollisionDetector
{
    // Rect collision tests the edges of each rect to
    // test whether the objects are overlapping the other
    public static function isColliding(e1 :Entity, e2 :Entity) : Bool
    {
        var e1Sprite = e1.get(Sprite);
        // Store the collider and collidee edges
        var l1 = getLeft(e1Sprite);
        var t1 = getTop(e1Sprite);
        var r1 = getRight(e1Sprite);
        var b1 = getBottom(e1Sprite);

        var e2Sprite = e2.get(Sprite);
        var l2 = getLeft(e2Sprite);
        var t2 = getTop(e2Sprite);
        var r2 = getRight(e2Sprite);
        var b2 = getBottom(e2Sprite);

        // If the any of the edges are beyond any of the
        // others, then we know that the box cannot be
        // colliding
        if (b1 < t2 || t1 > b2 || r1 < l2 || l1 > r2) {
            return false;
        }

        // If the algorithm made it here, it had to collide
        return true;
    };


    public static function resolveElastic(player :Entity, other :Entity) : Void
    {
        // Find the mid points of the entity and player
        var playerSprite = player.get(Sprite);
        var playerPhys = player.get(Phys);
        var pMidX = getMidX(playerSprite);
        var pMidY = getMidY(playerSprite);
        var otherSprite = other.get(Sprite);
        var otherPhys = other.get(Phys);
        var aMidX = getMidX(otherSprite);
        var aMidY = getMidY(otherSprite);

        // To find the side of entry calculate based on
        // the normalized sides
        var dx = (aMidX - pMidX) / otherSprite.naturalWidth()/2;
        var dy = (aMidY - pMidY) / otherSprite.naturalHeight()/2;

        // Calculate the absolute change in x and y
        var absDX = Math.abs(dx);
        var absDY = Math.abs(dy);

        // If the distance between the normalized x and y
        // position is less than a small threshold (.1 in this case)
        // then this object is approaching from a corner
        if (Math.abs(absDX - absDY) < .1) {

            // If the player is approaching from positive X
            if (dx < 0) {

                // Set the player x to the right side
                playerSprite.x = getRight(otherSprite);

            // If the player is approaching from negative X
            } else {

                // Set the player x to the left side
                playerSprite.x = getLeft(otherSprite) - playerSprite.naturalWidth();
            }

            // If the player is approaching from positive Y
            if (dy < 0) {

                // Set the player y to the bottom
                playerSprite.y = getBottom(otherSprite);

            // If the player is approaching from negative Y
            } else {

                // Set the player y to the top
                playerSprite.y = getTop(otherSprite) - playerSprite.naturalHeight();
            }

            // Randomly select a x/y direction to reflect velocity on
            if (Math.random() < .5) {

                // Reflect the velocity at a reduced rate
                playerPhys.vx = -playerPhys.vx * otherPhys.restitution;

                // If the object’s velocity is nearing 0, set it to 0
                // STICKY_THRESHOLD is set to .0004
                if (Math.abs(playerPhys.vx) < STICKY_THRESHOLD) {
                    playerPhys.vx = 0;
                }
            } 
            else {
                playerPhys.vy = -playerPhys.vy * otherPhys.restitution;
                if (Math.abs(playerPhys.vy) < STICKY_THRESHOLD) {
                    playerPhys.vy = 0;
                }
            }

        // If the object is approaching from the sides
        } else if (absDX > absDY) {

            // If the player is approaching from positive X
            if (dx < 0) {
                playerSprite.x = getRight(otherSprite);
            } 
            else {
                // If the player is approaching from negative X
                playerSprite.x = getLeft(otherSprite) - playerSprite.naturalWidth();
            }

            // Velocity component
            playerPhys.vx = -playerPhys.vx * otherPhys.restitution;

            if (Math.abs(playerPhys.vx) < STICKY_THRESHOLD) {
                playerPhys.vx = 0;
            }

        // If this collision is coming from the top or bottom more
        } 
        else {
            // If the player is approaching from positive Y
            if (dy < 0) {
                playerSprite.y = getBottom(otherSprite);
            } 
            else {
                // If the player is approaching from negative Y
                playerSprite.y = getTop(otherSprite) - playerSprite.naturalHeight();
            }

            // Velocity component
            playerPhys.vy = -playerPhys.vy * otherPhys.restitution;
            if (Math.abs(playerPhys.vy) < STICKY_THRESHOLD) {
                playerPhys.vy = 0;
            }
        }
    };

    // Getters for the mid point of the rect
    private static function getMidX(sprite :Sprite) : Float
    {
        return sprite.naturalWidth()/2 + sprite.x;
    }

    private static function getMidY(sprite :Sprite) : Float
    {
        return sprite.naturalHeight()/2 + sprite.y;
    }

    // Getters for the top, left, right, and bottom
    // of the rectangle
    private static function getTop(sprite :Sprite) :Float
    {
        return sprite.y;
    }

    private static function getLeft(sprite :Sprite) :Float
    {
        return sprite.x;
    }

    private static function getRight(sprite :Sprite) :Float
    {
        return sprite.x + sprite.naturalWidth();
    }

    private static function getBottom(sprite :Sprite) :Float
    {
        return sprite.y + sprite.naturalHeight();
    }


    private static inline var STICKY_THRESHOLD = .0004;
}