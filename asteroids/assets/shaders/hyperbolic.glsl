#include "../../../assets/shaders/common.glsl"
#include "../../../assets/shaders/complex.glsl"

uniform vec2 uq;
uniform vec2 up;
uniform vec2 udir;

uniform sampler2D uBackground;

varying vec2 vCoord;

#ifdef VERTEX_SHADER
void main(void)
{
    gl_Position = vec4(aVertexPosition, 1.0);
    vCoord = 2.0*aTextureCoord-1.0;
}
#endif

#ifdef FRAGMENT_SHADER

#define M_PI 3.1415926535897932384626433832795
float sqr2 = sqrt(2.0);
float sqr4 = sqrt(sqr2);
float l = (sqr4+1.0/sqr4)/2.0;
float C = l/cos(M_PI/8.0);
float R = C*tan(M_PI/8.0);

vec2 inversion(vec2 z, vec2 z0, float k) {
    float l=length(z-z0);
    return z0+k*k*(z-z0)/(l*l);
}

vec2 reflection_origin(vec2 z, vec2 d) {
    float f=2.0*dot(z,d)/dot(d,d);
    return f*d-z;
}

vec2 glue(vec2 z, vec2 c) {
    vec2 perp=vec2(-c.y,c.x);
    return inversion(reflection_origin(z,perp),-c,R);
}

vec2 inv_trans(vec2 z, vec2 a, vec2 d) {
    z=cx_div(z-a,vec2(1.0,0.0)-cx_mul(cx_conj(a),z));
    z=8.0*cx_div(z,d);
    return z;
}

bool inside_tex(vec2 zn, vec2 a, vec2 d) {
    zn=inv_trans(zn,a,d);
    float m=max(abs(zn.x),abs(zn.y));
    if(m<=1.0) {
        gl_FragColor = texture2D(uTexture,0.5*(zn+1.0));
        return true;
    }
    return false;
}

void main(void)
{
    vec2 z=vCoord;
    vec2 d=udir;
    vec2 a=uq;
    vec2 octagon[8];
    octagon[0]=C*vec2(1.0,0.0);
    octagon[1]=C*vec2(sqr2/2.0,sqr2/2.0);
    octagon[2]=C*vec2(0.0,1.0);
    octagon[3]=C*vec2(-sqr2/2.0,sqr2/2.0);
    octagon[4]=C*vec2(-1.0,0.0);
    octagon[5]=C*vec2(-sqr2/2.0,-sqr2/2.0);
    octagon[6]=C*vec2(0.0,-1.0);
    octagon[7]=C*vec2(sqr2/2.0,-sqr2/2.0);
    if(length(z)>=1.0) {
        gl_FragColor = vec4(1.0,0.3,0.0,0.5);
        return;
    }
    if( (length(z-octagon[0])<R)||
    	(length(z-octagon[1])<R)||
    	(length(z-octagon[2])<R)||
    	(length(z-octagon[3])<R)||
    	(length(z-octagon[4])<R)||
    	(length(z-octagon[5])<R)||
    	(length(z-octagon[6])<R)||
    	(length(z-octagon[7])<R) ) {
      gl_FragColor = vec4(1.0,0.0,0.0,0.5);
      return;
    }
    if(inside_tex(glue(z,octagon[0]), a, d)) return;
    if(inside_tex(glue(z,octagon[1]), a, d)) return;
    if(inside_tex(glue(z,octagon[2]), a, d)) return;
    if(inside_tex(glue(z,octagon[3]), a, d)) return;
    if(inside_tex(glue(z,octagon[4]), a, d)) return;
    if(inside_tex(glue(z,octagon[5]), a, d)) return;
    if(inside_tex(glue(z,octagon[6]), a, d)) return;
    if(inside_tex(glue(z,octagon[7]), a, d)) return;
    if(!inside_tex(z, a, d)) 
        discard;
}

#endif
