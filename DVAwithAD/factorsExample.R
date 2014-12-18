colors <- c("green", "red", "yellow", "blue")
colors_factors <- factor(colors)
# Try out 
# class(colors_factors) -> factor
# typeof(colors_factors) -> integer
# unclass(colors_factors) -> see the internal representation (removing class attributes)
# colors_factors[1] > colors_factors[2] -> not meaningful