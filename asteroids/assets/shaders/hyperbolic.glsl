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
void main(void)
{
    vec2 z=vCoord;
    vec2 d=udir;
    if(length(z)>=1.0) discard;
    vec2 a=uq;
    //vec2 a=vec2(0,0);
    z=-8.0*cx_div(z-a,cx_mul(cx_conj(a),z)-vec2(1.0,0.0));
    z=cx_div(z,d);
    float m=max(abs(z.x),abs(z.y));
    if(m<=1.0)
      gl_FragColor = texture2D(uTexture,0.5*(z+1.0));
}
#endif
