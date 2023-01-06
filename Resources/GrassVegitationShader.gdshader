shader_type spatial;
render_mode depth_draw_alpha_prepass, cull_disabled, diffuse_lambert_wrap, specular_disabled, async_visible;

uniform float ScalarUniform = 1;
uniform float freq = 1;
uniform float size = 1;
uniform vec4 ColorUniform : hint_color;
uniform sampler2D TextureUniform;



void vertex() {
// ScalarUniform:10
	float n_out10p0 = ScalarUniform;

// Input:7
	vec3 n_out7p0 = vec3(UV, 0.0);

// VectorDecompose:9
	float n_out9p0 = n_out7p0.x;
	float n_out9p1 = n_out7p0.y;
	float n_out9p2 = n_out7p0.z;

// Input:2
	float n_out2p0 = TIME;

// ScalarUniform:15
	float n_out15p0 = freq;

// ScalarOp:16
	float n_out16p0 = n_out2p0 * n_out15p0;

// ScalarUniform:17
	float n_out17p0 = size;

// Input:13
	vec3 n_out13p0 = VERTEX;

// VectorOp:18
	vec3 n_out18p0 = vec3(n_out17p0) * n_out13p0;

// VectorOp:14
	vec3 n_out14p0 = vec3(n_out16p0) + n_out18p0;

// VectorFunc:4
	vec3 n_out4p0 = sin(n_out14p0) + vec3(2.0)*sin(n_out14p0/vec3(1000));

// VectorOp:6
	vec3 n_in6p1 = vec3(0.10000, 0.00000, 0.00000);
	vec3 n_out6p0 = n_out4p0 * n_in6p1;

// VectorOp:8
	vec3 n_out8p0 = vec3(n_out9p1) * n_out6p0;

// VectorOp:12
	vec3 n_out12p0 = vec3(n_out10p0) * n_out8p0;

// Input:3
	vec3 n_out3p0 = VERTEX;

// VectorOp:5
	vec3 n_out5p0 = n_out12p0 + n_out3p0;

// Output:0
	VERTEX = n_out5p0;

}

void fragment() {
// ColorUniform:11
	vec3 n_out11p0 = ColorUniform.rgb;
	float n_out11p1 = ColorUniform.a;

// Input:6
	vec3 n_out6p0 = vec3(UV, 0.0);

// VectorDecompose:7
	float n_out7p0 = n_out6p0.x;
	float n_out7p1 = n_out6p0.y;
	float n_out7p2 = n_out6p0.z;

// VectorOp:8
	vec3 n_out8p0 = n_out11p0 * vec3(n_out7p1);

// TextureUniform:10
	vec3 n_out10p0;
	float n_out10p1;
	{
		vec4 n_tex_read = texture(TextureUniform, UV.xy);
		n_out10p0 = n_tex_read.rgb;
		n_out10p1 = n_tex_read.a;
	}

// ScalarOp:9
	float n_in9p1 = 1.00000;
	float n_out9p0 = n_out10p1 * n_in9p1;

// Scalar:3
	float n_out3p0 = 0.000000;

// Scalar:4
	float n_out4p0 = 1.000000;

// Output:0
	ALBEDO = n_out8p0;
	ALPHA = n_out9p0;
	METALLIC = n_out3p0;
	ROUGHNESS = n_out4p0;
	SPECULAR = n_out3p0;

}

void light() {
// Output:0

}
