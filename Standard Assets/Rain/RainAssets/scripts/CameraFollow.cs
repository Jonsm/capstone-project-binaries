using UnityEngine;
using System.Collections;

public class CameraFollow : MonoBehaviour {

	// Use this for initialization
	void Start () {
		this.gameObject.transform.position = new Vector3(Camera.main.gameObject.transform.position.x,
		                                                 Camera.main.gameObject.transform.position.y+ 200,
		                                                 Camera.main.gameObject.transform.position.z);

	}	
	
	// Update is called once per frame
	void Update () {
		this.gameObject.transform.position = new Vector3(Camera.main.gameObject.transform.position.x,
		                                                 Camera.main.gameObject.transform.position.y+ 200,
		                                                 Camera.main.gameObject.transform.position.z);

	}
}
