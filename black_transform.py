import numpy as np
import matplotlib.pyplot as plt

# Fixed image 2D points
fixed_image_points = np.array([
    [0, 0],
    [0, 2840],
    [2840, 2840],
    [2840, 0]
])

# Moving image 2D points
moving_image_points = np.array([
    [0, 0],
    [0, 1536],
    [2048, 1536],
    [2048, 0]
])

# Homography transformation matrix
H = np.array([
    [-0.056760899680704, -1.25552034616934, 2366.61161464409],
    [-1.25252378741972, 0.0571152156685343, 2848.93612389548],
    [0, 0, 1]
])

# Convert points to homogeneous coordinates
moving_image_points_homogeneous = np.hstack((moving_image_points, np.ones((moving_image_points.shape[0], 1))))

# Apply homography transformation
transformed_image_points_homogeneous = np.dot(H, moving_image_points_homogeneous.T).T

# Convert back to Cartesian coordinates
transformed_image_points = transformed_image_points_homogeneous[:, :2] / transformed_image_points_homogeneous[:, 2:]

print(transformed_image_points)

# Plot fixed image points in gray
plt.scatter(fixed_image_points[:, 0], fixed_image_points[:, 1], c='gray', label='Fixed Image Points')
# Connect the fixed image points to form a rectangle
for i in range(len(fixed_image_points)):
    next_i = (i + 1) % len(fixed_image_points)
    plt.plot([fixed_image_points[i, 0], fixed_image_points[next_i, 0]], [fixed_image_points[i, 1], fixed_image_points[next_i, 1]], 'gray')
# Label the fixed image points
for i, fixed in enumerate(fixed_image_points, start=1):
    plt.text(fixed[0], fixed[1], str(i), color='gray', fontsize=12, verticalalignment='bottom')

# Plot moving image points in green
plt.scatter(moving_image_points[:, 0], moving_image_points[:, 1], c='green', label='Moving Image Points')
# Connect the moving image points to form a rectangle
for i in range(len(moving_image_points)):
    next_i = (i + 1) % len(moving_image_points)
    plt.plot([moving_image_points[i, 0], moving_image_points[next_i, 0]], [moving_image_points[i, 1], moving_image_points[next_i, 1]], 'green')

# Plot transformed image points in red
plt.scatter(transformed_image_points[:, 0], transformed_image_points[:, 1], c='red', label='Transformed Image Points')
# Connect the transformed image points to form a rectangle
for i in range(len(transformed_image_points)):
    next_i = (i + 1) % len(transformed_image_points)
    plt.plot([transformed_image_points[i, 0], transformed_image_points[next_i, 0]], [transformed_image_points[i, 1], transformed_image_points[next_i, 1]], 'red')

# Label the moving and transformed image points
for i, (mov, trans) in enumerate(zip(moving_image_points, transformed_image_points), start=1):
    plt.text(mov[0], mov[1], str(i), color='green', fontsize=12, verticalalignment='bottom')
    plt.text(trans[0], trans[1], str(i), color='red', fontsize=12, verticalalignment='bottom')

# Set labels
plt.xlabel('X', color='white')
plt.ylabel('Y', color='white')
plt.gca().invert_yaxis()  # Invert y-axis to have the origin at the top-left corner

# Set the aspect ratio to 1:1
plt.gca().set_aspect('equal', adjustable='box')

# Move x-axis to the top
plt.gca().xaxis.tick_top()
plt.gca().xaxis.set_label_position('top')

# Set axis tick color
plt.tick_params(axis='x', colors='white')
plt.tick_params(axis='y', colors='white')

# Remove borders
for spine in plt.gca().spines.values():
    spine.set_visible(False)

# Create legend outside the plot area
plt.legend(loc='upper left', bbox_to_anchor=(1, 1), facecolor='black', frameon=False, fontsize=10, labelcolor='white')

# Set black background
plt.gcf().patch.set_facecolor('black')
plt.gca().set_facecolor('black')

# Remove grid
plt.grid(False)

# Show plot
plt.show()
