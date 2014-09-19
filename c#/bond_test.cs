/* C# Test Question

We have a bond with the following attributes:
*   maturity: 2012-12-15
*   coupon: 4.55%
*   frequency: semi-annual
*   accrual: ACT/365
Write a program to produce daily accrued interest and cashflow for each day in 2011 and 2012.
The result should be a file with 731 rows (one for each day) and 3 columns: date, accrued.interest, cashflow.

Kirk's Notes: 
    - this is a 2012 code sample for a hedge fund test, I was offered the job.
    - this file compiles and is correct.
*/

using System;
using System.Collections.Generic;
using System.Text;
using System.IO;

namespace bondtask
{
    class klsbond
    {
        static void Main()
        {
            /* 2012 is a leap year.
             */
            string filePath = @"c:\temp\bond_data.txt";
            
            ///Set up the basics.
            DateTime maturityDate = new DateTime(2012, 12, 15);
            double Period = 2;
            double Face = 100;
            double daysInYear = 365;
            double Coupon = .0455;
            DateTime startDate = new DateTime(2011, 01, 01);
            /// Extra day for handling C# Date issues. Can be changed.
            DateTime endDate = new DateTime(2013, 01, 01);

            double couponPayment = Coupon * Face / Period;
            double remainingDaysBond = (maturityDate - startDate).Days;
            ///Keep remainingCoupons out of loop to avoid Math.Ceiling error on June 16 2011 due to leap year.
            double remainingCoupons = Math.Ceiling(remainingDaysBond / (daysInYear / 2));
            int i = 0;

            string[,] output = new string[732,3];

            /// Loop through every day in 2011 and 2012
            for (DateTime date = startDate; date.Date <= endDate.Date; date = date.AddDays(1))
            {                
                ///Calculate Current date in coupon cycle.
                DateTime priorCouponDate = maturityDate.AddMonths(Convert.ToInt32( ((-6) * (remainingCoupons))));
                DateTime nextCouponDate = maturityDate.AddMonths(Convert.ToInt32(((-6) * (remainingCoupons - 1))));
                double elapsedDaysCurrentCoupon = (date - priorCouponDate).Days;
                double remainingDaysCurrentCoupon = (nextCouponDate - date).Days;
                double totalCouponDays = (nextCouponDate - priorCouponDate).Days;
				
				///Use current date in cycle to calc Accrued Interest
                double accruedInterest = couponPayment * elapsedDaysCurrentCoupon / totalCouponDays;

                ///Set cashflow to show up only on coupon pay dates and maturity.
                double cashFlow;
                if (date == nextCouponDate)
                {
                    if (date == maturityDate)
                    {
                        cashFlow = couponPayment + Face;
                    }
                    else
                    {
                        cashFlow = couponPayment;
                    }
                    remainingCoupons--;
                }
                else { cashFlow = 0; }

                ///Have accInt as zero post-maturity
                if (remainingCoupons == 0)
                {
                    accruedInterest = 0;
                }

                output[i,0] = date.ToShortDateString();
                output[i,1] = Convert.ToString(accruedInterest);
                output[i,2] = Convert.ToString(cashFlow);

                i++;
            }

            ///Simple CSV output.
            StreamWriter writer = new StreamWriter(filePath);
            writer.WriteLine("Date,Accrued Interest,Cash Flow");
            for (int j = 0; j < output.GetLength(0) - 1; j += 1)
            {
                writer.WriteLine(output[j, 0] + "," + output[j, 1] + "," + output[j, 2]);                
            }

            writer.Close();           
            
        }
    }


}
