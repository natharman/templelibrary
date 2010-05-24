/*
 *	 
 *	Temple Library for ActionScript 3.0
 *	Copyright © 2010 MediaMonks B.V.
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
 */

package temple.ui.buttons.behaviors 
{

	/**
	 * @author Thijs Broerse
	 */
	public class ButtonTimelineLabels 
	{
		/**
		 * Normal status of a button. Displayed when the mouse is not over the button.
		 * <p>This is a non-animated state and uses only one frame.</p>
		 * <p>If there is no 'up' defined, the first frame is used for 'up'.</p>
		 */
		public static const UP:String = 'up';
		
		/**
		 * Displayed when the mouse enters the buttons. The 'in' status is automaticly followed by the 'over' status.
		 * <p>This is an animated state and can use multiple frames. The last frame of this state is the frame before the next label (which isn't at the same frame).</p>
		 */
		public static const IN:String = 'in';
		
		/**
		 * Displayed when the mouse hovers the button.
		 * <p>This is a non-animated state and uses only one frame.</p>
		 * <p>If there is no labels defined, the last frame is used for 'over'. If there is no 'over' label, but there are other labels, 'up' is used as 'over'.
		 * If there are no 'in' and 'out' defined, the ButtonTimelineBehavior will animatie between 'up' and 'over' label</p>
		 */
		public static const OVER:String = 'over';
		
		/**
		 * Displayed when the mouse leaves the button. The 'out' status is automaticly followed by the 'up' status.
		 * <p>This is an animated state and can use multiple frames. The last frame of this state is the frame before the next label (which isn't at the same frame).</p>
		 */
		public static const OUT:String = 'out';
		
		/**
		 * Displayed when the left mouse button is pressed over the button. The 'press' status is automaticly followed by the 'down' status.
		 * <p>This is an animated state and can use multiple frames. The last frame of this state is the frame before the next label (which isn't at the same frame).</p>
		 */
		public static const PRESS:String = 'press';
		
		/**
		 * Displayed when the left mouse button is down.
		 * <p>This is a non-animated state and uses only one frame.</p>
		 * <p>If there are no 'press' and 'release' defined, the ButtonTimelineBehavior will animatie between 'over' and 'down' label</p>
		 */
		public static const DOWN:String = 'down';
		
		/**
		 * Displayed when the left mouse button is released. The 'release' status is automaticly followed by the 'over' status.
		 * <p>This is an animated state and can use multiple frames. The last frame of this state is the frame before the next label (which isn't at the same frame).</p>
		 */
		public static const RELEASE:String = 'release';
		
		/**
		 * Animation state before the selected state. The 'select' status is automaticly followed by the 'selected' status.
		 * <p>This is an animated state and can use multiple frames. The last frame of this state is the frame before the next label (which isn't at the same frame).</p>
		 */
		public static const SELECT:String = 'select';
		
		/**
		 * Displayed when the button is selected.
		 * <p>This is a non-animated state and uses only one frame.</p>
		 * <p>If there is no 'selected' defined, the last frame is used for 'selected'. If there are no 'select' and 'deselect' defined, the ButtonTimelineBehavior will animatie between 'up' and 'select' label</p>
		 */
		public static const SELECTED:String = 'selected';

		/**
		 * Animation state after the selected state.
		 * <p>This is an animated state and can use multiple frames. The last frame of this state is the frame before the next label (which isn't at the same frame).</p>
		 */
		public static const DESELECT:String = 'deselect';
		
		/**
		 * Animation state before the disable state. The 'disable' status is automaticly followed by the 'disabled' status.
		 * <p>This is an animated state and can use multiple frames. The last frame of this state is the frame before the next label (which isn't at the same frame).</p>
		 */
		public static const DISABLE:String = 'disable';
		
		/**
		 * Displayed when the button is disabled.
		 * <p>This is a non-animated state and uses only one frame.</p>
		 */
		public static const DISABLED:String = 'disabled';
		
		/**
		 * Animation state after the disable state.
		 * <p>This is an animated state and can use multiple frames. The last frame of this state is the frame before the next label (which isn't at the same frame).</p>
		 */
		public static const ENABLE:String = 'enable';
		
		/**
		 * Animation state when the buttons gets focus. The 'focus' state is automaticly followed by the 'focused' state.
		 * <p>This is an animated state and can use multiple frames. The last frame of this state is the frame before the next label (which isn't at the same frame).</p>
		 */
		public static const FOCUS:String = 'focus';

		/**
		 * Displayed when the button has focus.
		 */
		public static const FOCUSED:String = 'focused';

		/**
		 * Animation state when the button loses focus.
		 * <p>This is an animated state and can use multiple frames. The last frame of this state is the frame before the next label (which isn't at the same frame).</p>
		 */
		public static const BLUR:String = 'blur';
	}
}
