#define PI 3.14159265359

mat2 Rot(float a) {
    float s=sin(a), c=cos(a);
    return mat2(c, -s, s, c);
}

float Hash21(vec2 p) {
    p = fract(p*vec2(123.34, 456.21));
    p += dot(p, p+45.32);
    return fract(p.x*p.y);
}

vec3 palette( in float t )
{	
    vec3 a = vec3(0.5, 0.5, 0.5);
    vec3 b = vec3(0.5, 0.5, 0.5);
    vec3 c = vec3(1.0, 1.0, 1.0);
    vec3 d = vec3(0.00, 0.33, 0.67);

    return a + b*cos( 6.28318*(c*t+d) );
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 normalizedCoord = (fragCoord-.5*iResolution.xy)/iResolution.y;
    
    vec2 uv = (fragCoord-.5*iResolution.xy)/iResolution.y;
    uv *= fract(Hash21(vec2(20., 30.)));
    vec2 gv = fract(uv)-.5;
    
    float d = length(uv) * 1.5-length(uv); // change colour and pattern
    vec3 col = palette(d);
 
    // add more effects
    //float m = smoothstep(.7, .9, 1.-d);
    //col += m;
    
    float rays = 1.-fract(gv.x * gv.y*105.);
    col += rays;
    
    float angle = iTime * 0.31479;
    for (float i = 0.; i < 32.; i += 1.) {
        normalizedCoord = abs(normalizedCoord);
        normalizedCoord -= 1.5;
        normalizedCoord *= 0.5;
        normalizedCoord *= mat2(
            cos(angle), -sin(angle),
            .75*sin(angle), cos(angle)
        );
        normalizedCoord *= Rot(cos(iTime));
    }
    
    col *= vec3(
            length(normalizedCoord) * iTime,
            length(normalizedCoord + vec2(0.5, -0.5)),
            length(normalizedCoord + vec2(-1., -1.))
    );
    
    vec2 id = floor(uv);
    for(int y=-1;y<1;y++) {
        for(int x=-1;x<1;x++) {
            vec2 offs = vec2(x, y);
            float n = Hash21(id+offs);
            col *= sin(iTime*3.+n*6.2831)*.5+1.;
        }
    }
    
    // Output to screen
    fragColor = vec4(col,1.0);
}