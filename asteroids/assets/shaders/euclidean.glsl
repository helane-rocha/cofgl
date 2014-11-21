#include "../../../assets/shaders/common.glsl"
#include "../../../assets/shaders/complex.glsl"

uniform vec2 uq;
uniform vec2 up;
uniform vec2 udir;

varying vec2 vCoord;

#ifdef VERTEX_SHADER
void main(void)
{
    gl_Position = vec4(aVertexPosition, 1.0);
    vCoord = 2.0*aTextureCoord-1.0;
}
#endif

#ifdef FRAGMENT_SHADER

vec2 inv_trans(vec2 z, vec2 a, vec2 d) {
    z=z-a;
    z=8.0*cx_div(z,d);
    return z;
}

bool inside_tex(vec2 zn, vec2 a, vec2 d) {
    float m;
    zn=inv_trans(zn,a,d);
    m=max(abs(zn.x),abs(zn.y));
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
    float m=max(abs(z.x),abs(z.y));
    if(m>0.5) {
        if(inside_tex(z+vec2(2.0,0.0), a, d)) return;
        if(inside_tex(z-vec2(2.0,0.0), a, d)) return;
        if(inside_tex(z+vec2(0.0,2.0), a, d)) return;
        if(inside_tex(z-vec2(0.0,2.0), a, d)) return;
    }
    if(!inside_tex(z, a, d)) 
        discard;
}

#endif
