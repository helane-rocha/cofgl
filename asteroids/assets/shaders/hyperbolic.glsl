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
    vec2 refl[8];
    refl[0]=vec2(0.0, 1.0);
    refl[1]=vec2(-1.0, 1.0);
    refl[2]=vec2(1.0, 0.0);
    refl[3]=vec2(1.0, 1.0);
    refl[4]=vec2(0.0, 1.0);
    refl[5]=vec2(-1.0, 1.0);
    refl[6]=vec2(1.0, 0.0);
    refl[7]=vec2(1.0, 1.0);
    vec2 octagon[8];
    octagon[0]=C*vec2(1.0,0.0);
    octagon[1]=C*vec2(sqr2/2.0,sqr2/2.0);
    octagon[2]=C*vec2(0.0,1.0);
    octagon[3]=C*vec2(-sqr2/2.0,sqr2/2.0);
    octagon[4]=C*vec2(-1.0,0.0);
    octagon[5]=C*vec2(-sqr2/2.0,-sqr2/2.0);
    octagon[6]=C*vec2(0.0,-1.0);
    octagon[7]=C*vec2(sqr2/2.0,-sqr2/2.0);
    vec2 octagon_gluing[8];
    octagon_gluing[0]=octagon[4];
    octagon_gluing[1]=octagon[5];
    octagon_gluing[2]=octagon[6];
    octagon_gluing[3]=octagon[7];
    octagon_gluing[4]=octagon[0];
    octagon_gluing[5]=octagon[1];
    octagon_gluing[6]=octagon[2];
    octagon_gluing[7]=octagon[3];
    if(length(z)>=1.0) {
        gl_FragColor = vec4(1.0,0.0,0.0,0.5);
        return;
    }
    for(int i=0;i<8;i++) {
        float l=length(z-octagon[i]);
        vec2 rr=refl[i];
        vec2 og=octagon_gluing[i];
        if(l<(1.3*R)) {
            if(l<R) {
                gl_FragColor = vec4(1.0,0.0,0.0,0.5);
                return;
            }
            //vec2 rr=refl[i];
            vec2 zn=reflection_origin(z, rr);
            zn=inversion(zn, og, R);
            if(inside_tex(zn, a, d)) return;
        }
    }
    //gl_FragColor = texture2D(uBackground,0.5*(z+1.0));
    inside_tex(z, a, d);
}

#endif
