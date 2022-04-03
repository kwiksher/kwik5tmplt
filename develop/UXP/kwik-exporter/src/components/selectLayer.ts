import { app } from 'photoshop';

const selectLayerByID = async (layerID: number) => {
	const actionObject = [
	  {
		_obj: 'select',
		_target: [
		  {
			_ref: 'layer',
			_id: layerID,
		  },
		],
		makeVisible: false,
		layerID: [layerID],
		_isCommand: false,
	  },
	];
	await app.batchPlay(actionObject, { modalBehavior: 'execute' });
  };

export default selectLayerByID;
