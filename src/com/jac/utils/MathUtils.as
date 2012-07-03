package com.jac.utils 
{
	
	/**
	 * A utility class to make common math functions more convenient.
	 */
	public class MathUtils 
	{//MathUtils class
	
		/**
		 * Converts degrees to radians. (PI/180)
		 * 
		 * @param	degrees number of degrees to convert to radians.
		 * @return  number of radians.
		 */
		static public function degToRad(degrees:Number):Number
		{//degToRad
			return degrees * (Math.PI / 180);
		}//degToRad
		
		/**
		 * Converts radians to degrees (180/PI)
		 * 
		 * @param	radians number of radians to convert to degrees.
		 * @return	number of degrees
		 */
		static public function radToDeg(radians:Number):Number
		{//radToDeg
			return radians * (180 / Math.PI);
		}//radToDeg
		
		/**
		 * Returns a random number between the minVal and the maxVal.
		 * 
		 * @param	minVal the minimum value that can be returned.
		 * @param	maxVal the maximum value that can be returned.
		 * @return	a random value between the minVal and maxVal.
		 */
		static public function rand(minVal:Number, maxVal:Number):Number
		{//rand
			var min:Number;
			var max:Number;
			var diff:Number;
			var tmpVal:Number;
			
			if (minVal > maxVal)
			{//swap
				min = maxVal;
				max = minVal;
			}//swap
			else
			{//default
				min = minVal;
				max = maxVal;
			}//default
			
			diff = max - min;
			tmpVal = Math.random() * diff;
			
			return min + tmpVal;
			
		}//rand
	
		/**
		 * Determines if <code>value</code> is within a certain range around <code>targetNum</code>
		 * 
		 * @param	value		the value to check the range of.
		 * @param	targetNum	the number that <code>value</code> needs to be in range of.
		 * @param	threshold	how far from <code>targetNum</code> <code>value</code> can be and still be within range.
		 * 
		 * @return	return <code>true</code> if within range, <code>false</code> otherwise.
		 */
		static public function isWithinThreshold(value:Number, targetNum:Number, threshold:Number):Boolean
		{//isWithinThreshold
			if (Math.abs(value - targetNum) <= threshold)
			{//true
				return true;
			}//true
			else
			{//false
				return false;
			}//false
		}//isWithinThreshold
		
		/**
		 * Clamps <code>value</code> to be within <code>minVla</code> and <code>maxVal</code>.
		 * @param	minVal the lowest <code>value</code> can be.
		 * @param	maxVal the highest <code>value</code> can be.
		 * @param	value  the value to clamp.
		 *
		 * @return	Returns <code>minVal</code> if <code>value</code> is lower than <code>minVal</code>.  Returns <code>maxVal</code> if <code>value</code> is higher than <code>maxVal</code>.  Returns <code>value</code> otherwise.
		 */
		static public function clamp(minVal:Number, maxVal:Number, value:Number):Number
		{//clamp
			if (value > maxVal)
			{//max
				return maxVal;
			}//max
			else if (value < minVal)
			{//min
				return minVal;
			}//min
			else
			{//value
				return value;
			}//value
		}//clamp
		
		/**
		 * Clamps the value based on <code>value</code>'s absolute value, and then the sign is re-applied after the clamping.
		 * So if <code>minVal</code> is 5 and <code>maxVal</code> is 10 and <code>value</code> is -13 the returned value is -10;
		 * If <code>value</code> was -4, -4 is returned.  If <code>value</code> was 6, 6 is returned.
		 * @param	minVal the lowest <code>value</code> can be.
		 * @param	maxVal the highest <code>value</code> can be.
		 * @param	value  the value to clamp.
		 * 
		 * @return 	returns the clamped value with the sign re-applied.
		 */
		static public function clampUnsignedCompare(minVal:Number, maxVal:Number, value:Number):Number
		{//clampNoSign
			var sign:int;
			var val:Number = Math.abs(value);
			
			//get sign
			if (value < 0)
			{//negative
				sign = -1;
			}//negative
			else
			{//positive
				sign = 1;
			}//positive
			
			if (val > maxVal)
			{//max
				return maxVal * sign;
			}//max
			else if (val < minVal)
			{//min
				return minVal * sign;
			}//min
			else
			{//value
				return value;
			}//value
		}//clampNoSign
		
		static public function getPercentChange($xVal:Number, $yVal:Number):Number
		{//getPercentChange
			var direction:Number = 0;
			var largerVal:Number;
			var smallerVal:Number;
			
			if ($xVal > $yVal)
			{//neg change
				largerVal = $xVal;
				smallerVal = $yVal;
				direction = -1;
			}//neg change
			else
			{//pos change
				largerVal = $yVal;
				smallerVal = $xVal;
				direction = 1;
			}//pos change
			
			return ((largerVal - smallerVal) / largerVal) * direction;
		}//getPercentChange
	}//MathUtils Class
	
}