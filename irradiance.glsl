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
    vec3 c = vec3(2.0, 1.0, 1.0);
    vec3 d = vec3(0.50, 0.20, 0.25);

    return a + b*cos( 6.28318*(c*t+d) );
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 normalizedCoord = (fragCoord-.5*iResolution.xy)/iResolution.y;
    vec2 uv = (fragCoord-.5*iResolution.xy)/iResolution.y;

    uv *= .25;
    uv *= 1.-fract(Hash21(vec2(-0.5, 2.75)));
    
    vec2 gv = fract(uv)-.5;
    
    float t = iTime*.05;
    gv *= Rot(t);
    
    float d = length(uv) * 1.5-length(uv); // change colour and pattern
    
    vec3 col = 0.5 + 0.5*cos(iTime+uv.xyx+vec3(0,2,4));
    
    float rays = 1.-fract(gv.x * gv.y*500.);
    col += rays;
    
    vec2 id = floor(uv);
    for(int y=-1;y<1;y++) {
        for(int x=-1;x<1;x++) {
            vec2 offs = vec2(x, y);
            float n = cos(Hash21(id+offs));
            col *= cos(iTime*.75+n*6.2831)*.5+1.;
        }
    }
    
    // Time varying pixel color
    col -= 0.5 + 0.5*cos(iTime+uv.xyx+vec3(0,2,4));
    
    // Output to screen
    fragColor = vec4(col,1.0);
}