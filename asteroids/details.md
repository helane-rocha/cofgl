Games in 2-manifolds
====================

Metric
------

$$ds^2=\frac{4(dx^2+dy^2)}{(1+K(x^2+y^2))^2}=\frac{4dz\overline{dz}}{(1+K|z|^2)^2}$$

$$\begin{align*}
\text{arctan}_K(z) &=\sum_{n=0}{\infty} \frac{K^nz^{2n+1}}{2n+1} \\
  &=\left\{
    \begin{array}{cc}
    \text{arctanh(z)}, & \text{ if }K=-1\\
    \text{z}, & \text{ if }K=0\\
    \text{arctan(z)}, & \text{ if }K=1
    \end{array}
    \right.
\end{align*}$$

$$d(z_1,z_2)=2arctan_K\left|\frac{z_1-z_2}{1-z_1\overline{z_2}}\right|$$

Isometries
---------------------

$$T_a(z)=\frac{z-a}{1+Kz\overline{a}}$$

$$R_\theta(z)=e^{i\theta}z$$

$$M(z)=-z$$

Geodesic Circle $(O,R)$
-----------------------

$$p=tg_K(\frac{R}{2})$$

$$\left(x-\frac{O_x(1+Kp^2)}{1-p^2K^2|O|^2}\right)^2+
\left(y-\frac{O_y(1+Kp^2)}{1-p^2K^2|O|^2}\right)^2=
\left(\frac{p(1+K|O|^2)}{1-p^2K^2|O|^2}\right)^2$$

Geodesic Update Rule
--------------------

$$L(q_x,q_y,p_x,p_y)=\frac{4(p_x^2+p_y^2)}{(1+K(q_x^2+q_y^2))^2}
$$L_d(q_x,q_y,q_x',q_y',h)=
hL(q_x,q_y,\frac{q_x'-q_x}{h},\frac{q_y'-q_y}{h})$$
