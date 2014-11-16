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
    z=cx_div(z-a,vec2(1.0,0.0)+cx_mul(cx_conj(a),z));
    z=8.0*cx_div(z,d);
    return z;
}

void main(void)
{
    vec2 z=vCoord;
    vec2 d=udir;
    vec2 a=uq;
    float l=length(z);
    if(l>=1.0) discard;
    if(l>0.7) {
        vec2 zn=-z/(l*l);
        zn=inv_trans(zn,a,d);
        float m=max(abs(zn.x),abs(zn.y));
        if(m<=1.0) {
            gl_FragColor = texture2D(uTexture,0.5*(zn+1.0));
            return;
        }
    }
    z=inv_trans(z,a,d);
    float m=max(abs(z.x),abs(z.y));
    if(m<=1.0)
      gl_FragColor = texture2D(uTexture,0.5*(z+1.0));
}
#endif
