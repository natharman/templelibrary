/*
 *	 
 *	Temple Library for ActionScript 3.0
 *	Copyright © 2012 MediaMonks B.V.
 *	All rights reserved.
 *	
 *	http://code.google.com/p/templelibrary/
 *	
 *	Redistribution and use in source and binary forms, with or without
 *	modification, are permitted provided that the following conditions are met:
 *	
 *	- Redistributions of source code must retain the above copyright notice,
 *	this list of conditions and the following disclaimer.
 *	
 *	- Redistributions in binary form must reproduce the above copyright notice,
 *	this list of conditions and the following disclaimer in the documentation
 *	and/or other materials provided with the distribution.
 *	
 *	- Neither the name of the Temple Library nor the names of its contributors
 *	may be used to endorse or promote products derived from this software
 *	without specific prior written permission.
 *	
 *	
 *	Temple Library is free software: you can redistribute it and/or modify
 *	it under the terms of the GNU Lesser General Public License as published by
 *	the Free Software Foundation, either version 3 of the License, or
 *	(at your option) any later version.
 *	
 *	Temple Library is distributed in the hope that it will be useful,
 *	but WITHOUT ANY WARRANTY; without even the implied warranty of
 *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *	GNU Lesser General Public License for more details.
 *	
 *	You should have received a copy of the GNU Lesser General Public License
 *	along with Temple Library.  If not, see <http://www.gnu.org/licenses/>.
 *	
 *	
 *	Note: This license does not apply to 3rd party classes inside the Temple
 *	repository with their own license!
 *
 */

package temple.core.net 
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import temple.core.debug.IDebuggable;
	import temple.core.debug.Registry;
	import temple.core.debug.log.Log;
	import temple.core.debug.log.LogLevel;
	import temple.core.debug.objectToString;
	import temple.core.destruction.DestructEvent;
	import temple.core.destruction.IDestructibleOnError;
	import temple.core.events.EventListenerManager;
	import temple.core.templelibrary;

	/**
	 * @eventType temple.core.destruction.DestructEvent.DESTRUCT
	 */
	[Event(name = "DestructEvent.destruct", type = "temple.core.destruction.DestructEvent")]
	
	/**
	 * Base class for all URLLoaders in the Temple. The CoreURLLoader handles some core features of the Temple:
	 * <ul>
	 * 	<li>Registration to the Registry class.</li>
	 * 	<li>Event dispatch optimization.</li>
	 * 	<li>Easy remove of all EventListeners.</li>
	 * 	<li>Wrapper for Log class for easy logging.</li>
	 * 	<li>Completely destructible.</li>
	 * 	<li>Tracked in Memory (of this feature is enabled).</li>
	 * 	<li>Logs IOErrorEvents and SecurityErrorEvents.</li>
	 * </ul>
	 * 
	 * <p>You should always use and/or extend the CoreURLLoader instead of URLLoader if you want to make use of the Temple features.</p>
	 * 
	 * @see temple.core.Temple#registerObjectsInMemory
	 * 
	 * @author Thijs Broerse
	 */
	public class CoreURLLoader extends URLLoader implements ICoreLoader, IDestructibleOnError, IDebuggable
	{
		/**
		 * The current version of the Temple Library
		 */
		templelibrary static const VERSION:String = "3.0.0";
		
		private const _toStringProps:Vector.<String> = Vector.<String>(['url']);
		private var _registryId:uint;
		private var _eventListenerManager:EventListenerManager;
		private var _isDestructed:Boolean;
		private var _destructOnError:Boolean;
		private var _isLoading:Boolean;
		private var _isLoaded:Boolean;
		private var _logErrors:Boolean;
		private var _url:String;
		private var _emptyPropsInToString:Boolean = true;
		private var _debug:Boolean;

		/**
		 * Creates a CoreURLLoader
		 * @param request optional URLRequest to load
		 * @param destructOnError if set to true (default) this object wil automatically be destructed on an Error (IOError or SecurityError)
		 * @param logErrors if set to true an error message wil be logged on an Error (IOError or SecurityError)
		 */
		public function CoreURLLoader(request:URLRequest = null, destructOnError:Boolean = true, logErrors:Boolean = true)
		{
			this._destructOnError = destructOnError;
			this._logErrors = logErrors;
			
			// Register object for destruction testing
			this._registryId = Registry.add(this);
			
			// Add default listeners to Error events and preloader support
			// TODO: super
			this.addEventListener(ProgressEvent.PROGRESS, this.handleProgress);
			this.addEventListener(Event.COMPLETE, this.handleComplete);
			this.addEventListener(IOErrorEvent.IO_ERROR, this.handleIOError);
			this.addEventListener(IOErrorEvent.DISK_ERROR, this.handleIOError);
			this.addEventListener(IOErrorEvent.NETWORK_ERROR, this.handleIOError);
			this.addEventListener(IOErrorEvent.VERIFY_ERROR, this.handleIOError);
			this.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.handleSecurityError);
			
			super(request);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function load(request:URLRequest):void
		{
			if (this._isDestructed)
			{
				this.logWarn("load: This object is destructed (probably because 'desctructOnErrors' is set to true, so it cannot load anything");
				return;
			}
			if (this.debug) this.logDebug("load: " + request.url);
			
			this._url = request.url;
			this._isLoading = true;
			this._isLoaded = false;
			super.load(request);
		}

		/**
		 * @inheritDoc
		 * 
		 * Checks if the object is actually loading before call super.unload();
		 */ 
		override public function close():void
		{
			if (this._isLoading)
			{
				super.close();
				
				this._isLoading = false;
				this._url = null;
			}
			else if (this._debug) this.logInfo('Nothing is loading, so closing is useless');
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function get destructOnError():Boolean
		{
			return this._destructOnError;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set destructOnError(value:Boolean):void
		{
			this._destructOnError = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get isLoading():Boolean
		{
			return this._isLoading;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get isLoaded():Boolean
		{
			return this._isLoaded;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get url():String
		{
			return this._url;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get logErrors():Boolean
		{
			return this._logErrors;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set logErrors(value:Boolean):void
		{
			this._logErrors = value;
		}
		
		[Temple]
		/**
		 * @inheritDoc
		 */
		public final function get registryId():uint
		{
			return this._registryId;
		}
		
		/**
		 * @inheritDoc
		 * 
		 * Check implemented if object hasEventListener, must speed up the application
		 * http://www.gskinner.com/blog/archives/2008/12/making_dispatch.html
		 */
		override public function dispatchEvent(event:Event):Boolean 
		{
			if (this.hasEventListener(event.type) || event.bubbles) 
			{
				return super.dispatchEvent(event);
			}
			return true;
		}

		/**
		 * @inheritDoc
		 */
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void 
		{
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			if (this.getEventListenerManager()) this._eventListenerManager.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		/**
		 * @inheritDoc
		 */
		public function addEventListenerOnce(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0):void
		{
			if (this.getEventListenerManager()) this._eventListenerManager.addEventListenerOnce(type, listener, useCapture, priority);
		}

		/**
		 * @inheritDoc
		 */
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void 
		{
			super.removeEventListener(type, listener, useCapture);
			if (this._eventListenerManager) this._eventListenerManager.removeEventListener(type, listener, useCapture);
		}

		/**
		 * @inheritDoc
		 */
		public function removeAllStrongEventListenersForType(type:String):void 
		{
			if (this._eventListenerManager) this._eventListenerManager.removeAllStrongEventListenersForType(type);
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeAllOnceEventListenersForType(type:String):void
		{
			if (this._eventListenerManager) this._eventListenerManager.removeAllOnceEventListenersForType(type);
		}

		/**
		 * @inheritDoc
		 */
		public function removeAllStrongEventListenersForListener(listener:Function):void 
		{
			if (this._eventListenerManager) this._eventListenerManager.removeAllStrongEventListenersForListener(listener);
		}

		/**
		 * @inheritDoc
		 */
		public function removeAllEventListeners():void 
		{
			if (this._eventListenerManager) this._eventListenerManager.removeAllEventListeners();
		}
		
		
		[Temple]
		/**
		 * @inheritDoc
		 */
		public function get eventListenerManager():EventListenerManager
		{
			return this._eventListenerManager;
		}
		
		private function getEventListenerManager():EventListenerManager
		{
			if (this._isDestructed)
			{
				this.logError("Object is destructed, don't add event listeners");
				return null;
			}
			return this._eventListenerManager ||= new EventListenerManager(this);
		}

		/**
		 * @inheritDoc
		 */
		public function get debug():Boolean
		{
			return this._debug;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set debug(value:Boolean):void
		{
			this._debug = value;
		}

		/**
		 * Does a Log.debug, but has already filled in some known data.
		 * @param data the data to be logged
		 * 
		 * @see temple.core.debug.log.Log#debug()
		 * @see temple.core.debug.log.LogLevel#DEBUG
		 */
		protected final function logDebug(data:*):void
		{
			Log.templelibrary::send(data, this.toString(), LogLevel.DEBUG, this._registryId);
		}
		
		/**
		 * Does a Log.error, but has already filled in some known data.
		 * @param data the data to be logged
		 * 
		 * @see temple.core.debug.log.Log#error()
		 * @see temple.core.debug.log.LogLevel#ERROR
		 */
		protected final function logError(data:*):void
		{
			Log.templelibrary::send(data, this.toString(), LogLevel.ERROR, this._registryId);
		}
		
		/**
		 * Does a Log.fatal, but has already filled in some known data.
		 * @param data the data to be logged
		 * 
		 * @see temple.core.debug.log.Log#fatal()
		 * @see temple.core.debug.log.LogLevel#FATAL
		 */
		protected final function logFatal(data:*):void
		{
			Log.templelibrary::send(data, this.toString(), LogLevel.FATAL, this._registryId);
		}
		
		/**
		 * Does a Log.info, but has already filled in some known data.
		 * @param data the data to be logged
		 * 
		 * @see temple.core.debug.log.Log#info()
		 * @see temple.core.debug.log.LogLevel#INFO
		 */
		protected final function logInfo(data:*):void
		{
			Log.templelibrary::send(data, this.toString(), LogLevel.INFO, this._registryId);
		}
		
		/**
		 * Does a Log.status, but has already filled in some known data.
		 * @param data the data to be logged
		 * 
		 * @see temple.core.debug.log.Log#status()
		 * @see temple.core.debug.log.LogLevel#STATUS
		 */
		protected final function logStatus(data:*):void
		{
			Log.templelibrary::send(data, this.toString(), LogLevel.STATUS, this._registryId);
		}
		
		/**
		 * Does a Log.warn, but has already filled in some known data.
		 * @param data the data to be logged
		 * 
		 * @see temple.core.debug.log.Log#warn()
		 * @see temple.core.debug.log.LogLevel#WARN
		 */
		protected final function logWarn(data:*):void
		{
			Log.templelibrary::send(data, this.toString(), LogLevel.WARN, this._registryId);
		}
		
		/**
		 * List of property names which are output in the toString() method.
		 */
		protected final function get toStringProps():Vector.<String>
		{
			return this._toStringProps;
		}
		
		/**
		 * @private
		 *
		 * Possibility to modify the toStringProps array from outside, using the templelibrary namespace.
		 */
		templelibrary final function get toStringProps():Vector.<String>
		{
			return this._toStringProps;
		}
		
		/**
		 * A Boolean which indicates if empty properties are output in the toString() method.
		 */
		protected final function get emptyPropsInToString():Boolean
		{
			return this._emptyPropsInToString;
		}

		/**
		 * @private
		 */
		protected final function set emptyPropsInToString(value:Boolean):void
		{
			this._emptyPropsInToString = value;
		}

		/**
		 * @private
		 * 
		 * Possibility to modify the emptyPropsInToString value from outside, using the templelibrary namespace.
		 */
		templelibrary final function get emptyPropsInToString():Boolean
		{
			return this._emptyPropsInToString;
		}
		
		/**
		 * @private
		 */
		templelibrary final function set emptyPropsInToString(value:Boolean):void
		{
			this._emptyPropsInToString = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function toString():String
		{
			return objectToString(this, this.toStringProps, !this.emptyPropsInToString);
		}
		
		private function handleProgress(event:ProgressEvent):void
		{
			if (this.debug) this.logDebug("handleProgress: " + Math.round(100 * (event.bytesLoaded / event.bytesTotal)) + "%, loaded: " + event.bytesLoaded + ", total: " + event.bytesTotal);
		}
		
		private function handleComplete(event:Event):void
		{
			if (this._debug) this.logDebug("handleComplete");
			this._isLoading = false;
			this._isLoaded = true;
		}
		
		/**
		 * Default IOError handler
		 * 
		 * <p>If logErrors is set to true, an error message is logged</p>
		 */
		private function handleIOError(event:IOErrorEvent):void
		{
			this._isLoading = false;
			if (this._logErrors) this.logError(event.type + ': ' + event.text);
			if (this._destructOnError) this.destruct();
		}
		
		/**
		 * Default SecurityError handler
		 * 
		 * <p>If logErrors is set to true, an error message is logged</p>
		 */
		private function handleSecurityError(event:SecurityErrorEvent):void
		{
			this._isLoading = false;
			if (this._logErrors) this.logError(event.type + ': ' + event.text);
			if (this._destructOnError) this.destruct();
		}
		
		[Temple]
		/**
		 * @inheritDoc
		 */
		public final function get isDestructed():Boolean
		{
			return this._isDestructed;
		}

		/**
		 * @inheritDoc
		 */
		public function destruct():void 
		{
			if (this._isDestructed) return;
			
			this.dispatchEvent(new DestructEvent(DestructEvent.DESTRUCT));
			
			if (this._isLoading)
			{
				try
				{
					this.close();
				}
				catch(error:Error)
				{
					if (this.debug) this.logWarn("destruct: " + error.message);
				}
			}
			if (this._eventListenerManager)
			{
				this._eventListenerManager.destruct();
				this._eventListenerManager = null;
			}
			this._isDestructed = true;
		}
	}
}
