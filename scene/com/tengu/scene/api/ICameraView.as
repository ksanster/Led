/**
 * Created with IntelliJ IDEA.
 * User: a.semin
 * Date: 11.09.13
 * Time: 10:52
 * To change this template use File | Settings | File Templates.
 */
package com.tengu.scene.api
{
    public interface ICameraView extends IContainerView
    {
        function moveCamera (xCoord:Number, yCoord:Number):void;
        function setCameraSize (width:uint, height:uint):void;
        function setCameraScale (scale:Number):void;
        function setCameraRotation (angle:Number):void;
    }
}
