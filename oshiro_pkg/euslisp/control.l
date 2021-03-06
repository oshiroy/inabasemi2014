#!/usr/bin/env roseus

(load "package://hrpsys_ros_bridge_tutorials/euslisp/hrp2w-interface.l")
(hrp2w-init)
(objects *hrp2w*)

(ros::roseus "control")

(defun reset_pose ()
  (send *hrp2w* :reset-manip-pose)
  (send *ri* :angle-vector (send *hrp2w* :angle-vector) 3000)
  (send *ri* :wait-interpolation)
  )
(defun look_at ()
  (send *hrp2w* :head :look-at (send *hrp2w* :rarm :end-coords :pos))
  (send *ri* :angle-vector(send *hrp2w* :angle-vector) 3000)
  (send *ri* :wait-interpolation)
)
(defun pose1()
  (send *hrp2w* :rarm :shoulder-p :joint-angle -90)
  (send *hrp2w* :rarm :elbow-p :joint-angle 90)
  (send *ri* :angle-vector (send *hrp2w* :angle-vector) 5000)
  (send *ri* :wait-interpolation)
)
(defun pose2()
  (send *hrp2w* :rarm :shoulder-r :joint-angle -45)
  (send *hrp2w* :larm :shoilder-r :joint-angle 45)
  (send *hrp2w* :rarm :elbow-p :joint-angle 90)
  (send *hrp2w* :larm :elbow-p :joint-angle 90)
  (send *ri* :angle-vector (send *hrp2w* :angle-vector) 5000)
  (send *ri* :wait-interpolation)
)

(defun cmd_hrp2w (msg)
  (if (= (elt (send msg :buttons) 12) 1)
      (reset_pose)
    )
  (if (= (elt (send msg :buttons) 13) 1)
      (look_at)
    )
  (if (= (elt (send msg :buttons) 14) 1)
      (pose1)
    )
  (if (= (elt (send msg :buttons) 15) 1)
      (pose2)
    )
  )
(ros::subscribe "/joy" sensor_msgs::Joy #'cmd_hrp2w)


(do-until-key
 (ros::spin-once)
 )