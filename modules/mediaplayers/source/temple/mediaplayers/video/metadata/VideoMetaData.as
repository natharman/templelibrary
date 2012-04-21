/*
 *	Temple Library for ActionScript 3.0
 *	Copyright © MediaMonks B.V.
 *	All rights reserved.
 *	
 *	Redistribution and use in source and binary forms, with or without
 *	modification, are permitted provided that the following conditions are met:
 *	1. Redistributions of source code must retain the above copyright
 *	   notice, this list of conditions and the following disclaimer.
 *	2. Redistributions in binary form must reproduce the above copyright
 *	   notice, this list of conditions and the following disclaimer in the
 *	   documentation and/or other materials provided with the distribution.
 *	3. All advertising materials mentioning features or use of this software
 *	   must display the following acknowledgement:
 *	   This product includes software developed by MediaMonks B.V.
 *	4. Neither the name of MediaMonks B.V. nor the
 *	   names of its contributors may be used to endorse or promote products
 *	   derived from this software without specific prior written permission.
 *	
 *	THIS SOFTWARE IS PROVIDED BY MEDIAMONKS B.V. ''AS IS'' AND ANY
 *	EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 *	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 *	DISCLAIMED. IN NO EVENT SHALL MEDIAMONKS B.V. BE LIABLE FOR ANY
 *	DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 *	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 *	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 *	ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 *	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 *	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *	
 *	
 *	Note: This license does not apply to 3rd party classes inside the Temple
 *	repository with their own license!
 */

package temple.mediaplayers.video.metadata 
{
	import temple.common.interfaces.IObjectParsable;
	import temple.core.CoreObject;
	import temple.mediaplayers.video.cuepoints.VideoCuePoint;

	/**
	 * @author Thijs Broerse
	 */
	public class VideoMetaData extends CoreObject implements IObjectParsable
	{
		private var _audiocodecid:Number;
		private var _audiodatarate:Number;
		private var _audiodelay:Number;
		private var _canSeekToEnd:Boolean;
		private var _duration:Number;
		private var _framerate:Number;
		private var _height:Number;
		private var _videocodecid:Number;
		private var _videodatarate:Number;
		private var _width:Number;
		private var _cuePoints:Array;

		/**
		 * Constructor.
		 * @param data Object to parse, this should be a raw NetStream.onMetaData data object.   
		 */
		public function VideoMetaData(data:Object = null) 
		{
			if (data) this.parseObject(data);
		}

		/**
		 * @inheritDoc
		 */
		public function parseObject(object:Object):Boolean
		{
			this._audiocodecid = isNaN(object.audiocodecid) ? null : object.audiocodecid;
			this._audiodatarate = isNaN(object.audiodatarate) ? null : object.audiodatarate;
			this._audiodelay = isNaN(object.audiodelay) ? null : object.audiodelay;
			this._canSeekToEnd = (object.canSeekToEnd == undefined) ? false : object.canSeekToEnd;
			this._duration = isNaN(object.duration) ? null : object.duration;
			this._framerate = isNaN(object.framerate) ? null : object.framerate;
			this._height = isNaN(object.height) ? null : object.height;
			this._videocodecid = (object.videocodecid == undefined) ? null : object.videocodecid;
			this._videodatarate = isNaN(object.videodatarate) ? null : object.videodatarate;
			this._width = isNaN(object.width) ? null : object.width;
			
			if (object.cuePoints is Array)
			{
				var cuePoint:VideoCuePoint;
				this._cuePoints = [];
				for (var i:int = 0, leni:int = object.cuePoints.length; i < leni; i++)
				{
					cuePoint = new VideoCuePoint();
					cuePoint.parseObject(object.cuePoints[i]);
					this._cuePoints.push(cuePoint);
				}
			}
			
			return true;
		}

		/**
		 * A number that indicates the audio codec (code/decode technique) that was used
		 */
		public function get audiocodecid():Number
		{
			return this._audiocodecid;
		}
		
		/**
		 * A number that indicates the rate at which audio was encoded, in kilobytes per second
		 */
		public function get audiodatarate():Number
		{
			return this._audiodatarate;
		}
		
		/**
		 * A number that indicates what time in the FLV file "time 0" of the original FLV file exists
		 */
		public function get audiodelay():Number
		{
			return this._audiodelay;
		}
		
		/**
		 * A Boolean value that is true if the FLV file is encoded with a keyframe on the last frame that allows seeking to the end of a progressive download movie clip
		 */
		public function get canSeekToEnd():Boolean
		{
			return this._canSeekToEnd;
		}
		
		/**
		 * A number that specifies the duration of the FLV file, in seconds
		 */
		public function get duration():Number
		{
			return this._duration;
		}
		
		/**
		 * A number that is the frame rate of the FLV file
		 */
		public function get framerate():Number
		{
			return this._framerate;
		}
		
		/**
		 * A number that is the height of the FLV file, in pixels
		 */
		public function get height():Number
		{
			return this._height;
		}
		
		/**
		 * A number that is the codec version that was used to encode the video
		 */
		public function get videocodecid():Number
		{
			return this._videocodecid;
		}
		
		/**
		 * A number that is the video data rate of the FLV file
		 */
		public function get videodatarate():Number
		{
			return this._videodatarate;
		}
		
		/**
		 * A number that is the width of the FLV file, in pixels
		 */
		public function get width():Number
		{
			return this._width;
		}
		
		/**
		 * An array with cuePoints
		 */
		public function get cuePoints():Array
		{
			return this._cuePoints;
		}
	}
}