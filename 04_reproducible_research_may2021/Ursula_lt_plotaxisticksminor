
#!/usr/bin/Rscript

# Generate two panels (before and after)
par(mfrow = c(1, 2))

# Default look
# Generate default plot of the Guassain distribuction, same mean, different STD
# Define the x-Axis (from, to, by); by = increment of the sequence. Setting "by" to one will give you a coarse curve
# of 9 points (-4,-3-,-2,-1,0,1,2,3,4). Setting the "by" to 0.1 will give a smooth curve with 81 points. Setting'
# "by" to 0.0000001 crashes my computer.
x <- seq(-4, 4, 0.1)

# plot the first Gaussian distribution, Mean 0, sd 1 (if you leave out type = "l", you will get 81 points instead of a line)
plot(x, dnorm(x, mean =0, sd =1))

# Add a second line into the same plot, Mean 1, sd 0.3
lines(x, dnorm(x, mean = 0, sd = 0.4))

# Add a second line into the same plot, Mean 1, sd 1.5)
lines(x, dnorm(x, mean = 0, sd = 1.5))

# Same curves in my look
plot(x, dnorm(x, mean = 0, sd = 1), type = "l", xaxt = "n", yaxt = "n", ylim = c(0, 1), ylab = "", xlab = "", lwd = 3, col = "red")
axis(1, at = seq(-4, 4, 1), lwd = 0, lwd.tick = 1, cex.axis =2, tcl =-0.5) # x-axis, major tics, with label
axis(1, at = seq(-4, 4, 0.5), labels = NA, lwd = 0, lwd.tick =1, tcl = -0.2) # x-axis, minor tic
axis(2, at = seq(0, 1, 0.2), lwd = 0, lwd.tick = 1, cex.axis =2, tcl=-0.5, las=1) # las = label orientation
axis(2, at = seq(0, 1, 0.1), labels = NA, lwd = 0, lwd.tick =1, tcl=-0.2)

# Mean 1, sd 0.3
lines(x, dnorm(x, mean = 0, sd = 0.4), col = "blue", lty = 1, lwd = 3)

# Mean 1, sd 0.25
lines(x, dnorm(x, mean = 0, sd = 1.5), col = "green", lty = 1, lwd = 3)
